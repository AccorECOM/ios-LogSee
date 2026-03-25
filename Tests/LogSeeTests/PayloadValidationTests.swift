import Foundation
@testable import Logger
import Testing

struct PayloadValidationTests {
    private var analyticsChannel: LogChannel {
        LogChannel(id: "analytics_events", title: "Analytics: Events", emoji: "📊")
    }

    private var expectedKeys: [String] {
        ["requiredFieldA", "requiredFieldB"]
    }

    private var payloadValidationProvider: @Sendable (Logger.Log) -> Logger.Log.PayloadValidation? {
        { [expectedKeys] log in
            let missing = expectedKeys.filter { key in
                guard let value = log.env[key] else { return true }
                guard let stringValue = value as? String else { return false }
                return stringValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }

            return Logger.Log.PayloadValidation(
                eventIdentifier: log.message,
                expectedKeys: expectedKeys,
                missingKeys: missing
            )
        }
    }

    private func makeLogger() -> Logger {
        Logger(
            logger: LoggerRepository(),
            payloadValidationConfiguration: Logger.PayloadValidationConfiguration(
                channelID: analyticsChannel.id,
                provider: payloadValidationProvider
            )
        )
    }

    @Test("Payload validation marks analytics event as incomplete when expected keys are missing")
    func eventPayloadIsFlaggedAsIncompleteWhenMissingKeys() async throws {
        let logger = makeLogger()
        logger.log(
            Logger.Log(
                message: "eventSample",
                channel: analyticsChannel,
                env: [
                    "EventID": "eventSample",
                    "requiredFieldA": "valueA"
                ]
            )
        )

        try? await Task.sleep(nanoseconds: 50_000_000)
        let logs = await logger.get(for: analyticsChannel)

        #expect(logs.count == 1)
        #expect(logs[0].payloadValidation?.isComplete == false)
        #expect(logs[0].payloadValidation?.missingKeys == ["requiredFieldB"])
        #expect(logs[0].payloadValidation?.expectedKeys == ["requiredFieldA", "requiredFieldB"])
    }

    @Test("Payload validation marks analytics event as complete when all expected keys are present")
    func eventPayloadIsMarkedAsCompleteWhenNoKeyIsMissing() async throws {
        let logger = makeLogger()
        logger.log(
            Logger.Log(
                message: "eventSample",
                channel: analyticsChannel,
                env: [
                    "EventID": "eventSample",
                    "requiredFieldA": "valueA",
                    "requiredFieldB": "valueB"
                ]
            )
        )

        try? await Task.sleep(nanoseconds: 50_000_000)
        let logs = await logger.get(for: analyticsChannel)

        #expect(logs.count == 1)
        #expect(logs[0].payloadValidation?.isComplete == true)
        #expect(logs[0].payloadValidation?.missingKeys.isEmpty == true)
    }

    @Test("Payload validation ignores channels that are not configured")
    func payloadValidationCanBeScopedToSpecificChannels() async throws {
        let logger = makeLogger()
        let otherChannel = LogChannel(id: "analytics_other", title: "Analytics: Other", emoji: "📊")
        logger.log(
            Logger.Log(
                message: "eventSample",
                channel: otherChannel,
                env: [
                    "EventID": "eventSample"
                ]
            )
        )

        try? await Task.sleep(nanoseconds: 50_000_000)
        let logs = await logger.get(for: otherChannel)

        #expect(logs.count == 1)
        #expect(logs[0].payloadValidation == nil)
    }
}
