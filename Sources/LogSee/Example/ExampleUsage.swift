import Foundation
import Logger
import SwiftUI

// MARK: - Example Usage

struct ExampleUsage {
    static func demonstrateBasicUsage() {
        let logger = Logger.shared

        // Using default channels
        logger.log("Network request started", channel: .network)
        logger.log("User authenticated", channel: .auth)
        logger.log("Database query executed", channel: .database, level: .info)
        logger.log("Something went wrong", channel: .error, level: .error)

        // With environment data
        logger.log(
            "API call completed",
            channel: .network,
            level: .info,
            env: [
                "url": "https://api.example.com/users",
                "statusCode": 200,
                "duration": 0.35
            ]
        )
    }

    static func demonstrateCustomChannels() async {
        // Define custom channels for your app
        let customChannels = [
            LogChannel(id: "analytics", title: "Analytics", emoji: "📊"),
            LogChannel(id: "payment", title: "Payment", emoji: "💳"),
            LogChannel(id: "ui", title: "UI", emoji: "🎨"),
            LogChannel(id: "background", title: "Background", emoji: "⚙️")
        ]

        // Configure logger with custom channels
        await Logger.configure(channels: LogChannel.defaultChannels + customChannels)

        let logger = Logger.shared

        // Use custom channels
        if let analyticsChannel = await Logger.channel(id: "analytics") {
            logger.log("User event tracked", channel: analyticsChannel)
        }

        if let paymentChannel = await Logger.channel(id: "payment") {
            logger.log("Payment processed", channel: paymentChannel, level: .info)
        }
    }

    static func demonstrateAsyncUsage() async {
        let logger = Logger.shared

        // Get logs for a specific channel
        let networkLogs = await logger.get(for: .network)
        print("Network logs: \(networkLogs.count)")

        // Get all logs
        let allLogs = await logger.getAll()
        for (channel, logs) in allLogs {
            print("\(channel.emoji) \(channel.title): \(logs.count) logs")
        }

        // Clear logs for a specific channel
        await logger.clear(for: .debug)

        // Clear all logs
        await logger.clear()
    }

    static func demonstrateLogStreaming() {
        // Stream logs in real-time
        Task {
            for await log in Logger.logStream {
                print("📝 [\(log.channel.title)] \(log.message)")
            }
        }
    }

    static func demonstrateAvailableChannels() async {
        // Get all available channels
        let channels = await Logger.channels()
        print("Available channels:")
        for channel in channels {
            print("- \(channel.emoji) \(channel.title) (id: \(channel.id))")
        }

        // Find a specific channel
        if let networkChannel = await Logger.channel(id: "network") {
            print("Found network channel: \(networkChannel.title)")
        }
    }
}
