@testable import Logger
@testable import LogSee
import Testing

// MARK: - Logger Business Logic Tests

struct LoggerBusinessLogicTests {

    @Test("When I log a message, I can retrieve it from the same channel")
    func testLogMessageCanBeRetrievedFromCorrectChannel() async throws {
        // Given
        let logger = Logger(logger: LoggerRepository())
        let message = "User clicked login button"
        let channel = LogChannel.debug

        // When
        logger.log(message, channel: channel)

        // Allow async logging to complete
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then
        let retrievedLogs = await logger.get(for: channel)
        #expect(retrievedLogs.count == 1)
        #expect(retrievedLogs.first?.message == message)
    }

    @Test("When I log to different channels, each channel contains only its own logs")
    func testLogsAreSeparatedByChannel() async throws {
        // Given
        let logger = Logger(logger: LoggerRepository())
        let networkMessage = "API request to /users"
        let errorMessage = "Failed to parse response"

        // When
        logger.log(networkMessage, channel: .network)
        logger.log(errorMessage, channel: .error)

        // Allow async logging to complete
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then
        let networkLogs = await logger.get(for: .network)
        let errorLogs = await logger.get(for: .error)

        #expect(networkLogs.count == 1)
        #expect(networkLogs.first?.message == networkMessage)

        #expect(errorLogs.count == 1)
        #expect(errorLogs.first?.message == errorMessage)
    }

    @Test("When I clear logs for a channel, only that channel is emptied")
    func testClearingSpecificChannelOnlyAffectsThatChannel() async throws {
        // Given
        let logger = Logger(logger: LoggerRepository())

        logger.log("Network log", channel: .network)
        logger.log("Error log", channel: .error)

        // Allow async logging to complete
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // When
        await logger.clear(for: .network)

        // Then
        let networkLogs = await logger.get(for: .network)
        let errorLogs = await logger.get(for: .error)

        #expect(networkLogs.isEmpty)
        #expect(errorLogs.count == 1)
    }

    @Test("When I log with environment data, it is preserved with the log")
    func testLogEnvironmentDataIsPreserved() async throws {
        // Given
        let logger = Logger(logger: LoggerRepository())
        let environmentData: [String: any Sendable] = [
            "userId": "12345",
            "sessionId": "abc-def-ghi",
            "apiVersion": "v2"
        ]

        // When
        logger.log("User action", channel: .info, level: .info, env: environmentData)

        // Allow async logging to complete
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then
        let logs = await logger.get(for: .info)
        #expect(logs.count == 1)

        let logEnv = logs.first?.env ?? [:]
        #expect(logEnv["userId"] as? String == "12345")
        #expect(logEnv["sessionId"] as? String == "abc-def-ghi")
        #expect(logEnv["apiVersion"] as? String == "v2")
    }
}
