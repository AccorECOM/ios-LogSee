import Combine
import Foundation
import os

public struct Logger: Sendable {
    private let logger: LoggerRegistable
    private let channelManager: ChannelManager
    private let subsystem: String

    public static var logStream: AsyncStream<Logger.Log> {
        LogPublisher.shared.getStream()
    }

    public static let shared = Logger()

    public init(logger: LoggerRegistable = LoggerRepository.shared,
                channelManager: ChannelManager = ChannelManager(),
                subsystem: String = "com.LogSee.logs") {
        self.logger = logger
        self.channelManager = channelManager
        self.subsystem = subsystem
    }

    /// Configure the logger with available channels
    /// Call this once at app startup
    public static func configure(channels: [LogChannel]) async {
        await shared.channelManager.configure(channels: channels)
    }

    /// Get all available channels
    public static func channels() async -> [LogChannel] {
        await shared.channelManager.getChannels()
    }

    /// Get a channel by ID
    public static func channel(id: String) async -> LogChannel? {
        await shared.channelManager.getChannel(id: id)
    }

    public func log(
        _ message: String,
        channel: LogChannel,
        level: Log.Level = .debug,
        env: [String: any Sendable] = [:]
    ) {
        let log = Log(message: message, channel: channel, env: env, level: level)
        self.log(log)
    }

    public func log(_ log: Logger.Log) {
        #if DEBUG
        let timestamp = Date().formatted(date: .numeric, time: .standard)
        let logMessage = "[\(log.channel.title.uppercased())] [\(timestamp)] \(log.message)"

        // 🖥 Print to os.Logger (Xcode console with filters)
        os.Logger(subsystem: subsystem, category: log.channel.title)
            .log("\(logMessage, privacy: .public)")

        // 📦 Store in repository
        Task { [logger] in
            await logger.add(log)
        }

        LogPublisher.shared.send(log)
        #endif
    }

    public func get(for channel: LogChannel) async -> [Log] {
        #if DEBUG
        await logger.get(for: channel)
        #else
        return []
        #endif
    }

    public func getAll() async -> [LogChannel: [Logger.Log]] {
        #if DEBUG
        await logger.getAll()
        #else
        return [:]
        #endif
    }

    public func clear(for channel: LogChannel? = nil) async {
        #if DEBUG
        await logger.clear(for: channel)
        #endif
    }
}
