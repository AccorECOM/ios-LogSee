import Foundation
@testable import Logger
import Testing

// MARK: - Logger Storage Business Logic Tests
// These tests verify the business rules around log storage and retrieval,
// not the implementation details of the repository

struct LoggerStorageBusinessLogicTests {

    @Test("When I log multiple messages, they are stored in chronological order with newest first")
    func testLogsAreStoredInReverseChronologicalOrder() async {
        // Given
        let logger = Logger(logger: LoggerRepository())
        let channel = LogChannel.debug

        // When - Log messages with small delays to ensure different timestamps
        logger.log("First message", channel: channel)
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        logger.log("Second message", channel: channel)
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        logger.log("Third message", channel: channel)

        // Allow async logging to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then - Newest message should be first
        let logs = await logger.get(for: channel)
        #expect(logs.count == 3)
        #expect(logs[0].message == "Third message")
        #expect(logs[1].message == "Second message")
        #expect(logs[2].message == "First message")
    }

    @Test("When I log to multiple channels, each channel maintains its own history")
    func testChannelsHaveIndependentHistory() async {
        // Given
        let logger = Logger(logger: LoggerRepository())
        // When
        logger.log("Network: API call started", channel: .network)
        logger.log("Error: Connection timeout", channel: .error)
        logger.log("Network: Retrying request", channel: .network)
        logger.log("Debug: Cache miss", channel: .debug)

        // Allow async logging to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then
        let networkLogs = await logger.get(for: .network)
        let errorLogs = await logger.get(for: .error)
        let debugLogs = await logger.get(for: .debug)

        #expect(networkLogs.count == 2)
        #expect(networkLogs[0].message == "Network: Retrying request")
        #expect(networkLogs[1].message == "Network: API call started")

        #expect(errorLogs.count == 1)
        #expect(errorLogs[0].message == "Error: Connection timeout")

        #expect(debugLogs.count == 1)
        #expect(debugLogs[0].message == "Debug: Cache miss")
    }

    @Test("When I request all logs, I get a complete view of all channels")
    func testGetAllLogsReturnsCompleteHistory() async {
        // Given
        let logger = Logger(logger: LoggerRepository())
        // When
        logger.log("Network log", channel: .network)
        logger.log("Error log", channel: .error)
        logger.log("Info log", channel: .info)

        // Allow async logging to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then
        let allLogs = await logger.getAll()
        #expect(allLogs.count == 3)
        #expect(allLogs[.network]?.count == 1)
        #expect(allLogs[.error]?.count == 1)
        #expect(allLogs[.info]?.count == 1)
    }

    @Test("When I clear logs for a specific channel, other channels remain untouched")
    func testClearingOneChannelDoesNotAffectOthers() async {
        // Given
        let logger = Logger(logger: LoggerRepository())

        logger.log("Network log 1", channel: .network)
        logger.log("Network log 2", channel: .network)
        logger.log("Error log", channel: .error)
        logger.log("Debug log", channel: .debug)

        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        // When
        await logger.clear(for: .network)

        // Then
        let networkLogs = await logger.get(for: .network)
        let errorLogs = await logger.get(for: .error)
        let debugLogs = await logger.get(for: .debug)

        #expect(networkLogs.isEmpty)
        #expect(errorLogs.count == 1)
        #expect(debugLogs.count == 1)
    }

    @Test("When I clear all logs, the entire history is wiped")
    func testClearAllRemovesEverything() async {
        // Given
        let logger = Logger(logger: LoggerRepository())

        logger.log("Log 1", channel: .network)
        logger.log("Log 2", channel: .error)
        logger.log("Log 3", channel: .debug)
        logger.log("Log 4", channel: .info)

        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // When
        await logger.clear()

        // Then
        let allLogs = await logger.getAll()
        #expect(allLogs.isEmpty)
    }

    @Test("Log metadata is preserved accurately")
    func testLogMetadataIntegrity() async {
        // Given
        let logger = Logger(logger: LoggerRepository())
        let beforeLogging = Date()
        let metadata: [String: any Sendable] = [
            "requestId": "abc-123",
            "duration": 1.5,
            "statusCode": 200,
            "isRetry": true
        ]

        // When
        logger.log("API request completed", channel: .network, level: .info, env: metadata)
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        let afterLogging = Date()

        // Then
        let logs = await logger.get(for: .network)
        #expect(logs.count == 1)

        guard let log = logs.first else {
            #expect(Bool(false))
            return
        }
        #expect(log.date >= beforeLogging)
        #expect(log.date <= afterLogging)
        #expect(log.level == .info)
        #expect(log.env["requestId"] as? String == "abc-123")
        #expect(log.env["duration"] as? Double == 1.5)
        #expect(log.env["statusCode"] as? Int == 200)
        #expect(log.env["isRetry"] as? Bool == true)
    }

    @Test("I can discover which channels have logs")
    func testChannelDiscovery() async {
        // Given
        let logger = Logger(logger: LoggerRepository())

        // When - Log to some channels but not others
        logger.log("Network activity", channel: .network)
        logger.log("Database query", channel: .database)
        logger.log("Authentication check", channel: .auth)
        // Note: Not logging to .error, .debug, or .info

        // Allow async logging to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then - We can see which channels have logs by checking getAll()
        let allLogs = await logger.getAll()
        let channelsWithLogs = Set(allLogs.keys)

        #expect(channelsWithLogs.count == 3)
        #expect(channelsWithLogs.contains(.network))
        #expect(channelsWithLogs.contains(.database))
        #expect(channelsWithLogs.contains(.auth))
        #expect(!channelsWithLogs.contains(.error))
        #expect(!channelsWithLogs.contains(.debug))
    }
}
