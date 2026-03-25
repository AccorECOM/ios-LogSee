import Foundation
@testable import Logger
@testable import LogSee
import Testing

// MARK: - Logs View Business Logic Tests
// These tests focus on the business behavior of viewing and managing logs,
// not the implementation details of presenters, interactors, etc.

@MainActor
struct LogsViewBusinessLogicTests {

    // Helper to ensure clean state
    private func setupCleanEnvironment() async {
        UserDefaults.standard.removeObject(forKey: LiveStreamUseCase.Constants.liveStreamEnabledKey)
        UserDefaults.standard.removeObject(forKey: LiveStreamUseCase.Constants.enabledChannelsKey)
        UserDefaults.standard.synchronize()
    }

    @Test("When viewing logs, I can see all available log channels")
    func testAllLogChannelsAreVisible() async {
        // Given
        await setupCleanEnvironment()
        let logger = Logger(logger: LoggerRepository())

        // Log to different channels
        logger.log("Network request", channel: .network)
        logger.log("Database query", channel: .database)
        logger.log("Debug info", channel: .debug)

        // Allow async logging to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // When - Get all logs
        let allLogs = await logger.getAll()

        // Then - All channels with logs should be present
        #expect(allLogs.keys.contains(.network))
        #expect(allLogs.keys.contains(.database))
        #expect(allLogs.keys.contains(.debug))
    }

    @Test("When I clear all logs, the log history is empty")
    func testClearingAllLogsEmptiesHistory() async {
        // Given
        await setupCleanEnvironment()
        let logger = Logger(logger: LoggerRepository())

        logger.log("Test log 1", channel: .network)
        logger.log("Test log 2", channel: .error)
        logger.log("Test log 3", channel: .debug)

        // Allow async logging to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // When
        await logger.clear()

        // Then
        let allLogs = await logger.getAll()
        #expect(allLogs.isEmpty)
    }

    @Test("Log entries contain all required information for debugging")
    func testLogEntriesContainCompleteInformation() async {
        // Given
        await setupCleanEnvironment()
        let logger = Logger(logger: LoggerRepository())
        let message = "User authentication failed"
        let env: [String: any Sendable] = [
            "userId": "12345",
            "endpoint": "/api/auth",
            "errorCode": 401
        ]

        // When
        logger.log(message, channel: .error, level: .error, env: env)

        // Allow async logging to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Then
        let logs = await logger.get(for: .error)
        #expect(logs.count == 1)

        let log = logs.first!
        #expect(log.message == message)
        #expect(log.channel == .error)
        #expect(log.level == .error)
        #expect(log.env["userId"] as? String == "12345")
        #expect(log.env["endpoint"] as? String == "/api/auth")
        #expect(log.env["errorCode"] as? Int == 401)
        #expect(log.date.timeIntervalSinceNow < 1) // Log was created recently
    }

    @Test("When logs include custom channels, filters include these channels")
    func testFiltersIncludeCustomChannelsFromHistory() async {
        // Given
        let presenter = LogsView.Presenter()
        let customChannel = LogChannel(id: "analytics_events", title: "Analytics: Events", emoji: "📊")

        // When
        await presenter.setFiltres([.network, .error])
        presenter.setHistory([customChannel: [Logger.Log(message: "evt", channel: customChannel)]])

        // Then
        #expect(presenter.filters.contains(customChannel))
        #expect(presenter.currentFilter == customChannel || presenter.currentFilter == .error || presenter.currentFilter == .network)
    }
}
