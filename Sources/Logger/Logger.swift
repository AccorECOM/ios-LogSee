import Combine
import Foundation
import os

public struct Logger: Sendable {
    public struct PayloadValidationConfiguration: Sendable {
        public let channelID: String?
        public let provider: @Sendable (Logger.Log) -> Logger.Log.PayloadValidation?

        public init(
            channelID: String? = nil,
            provider: @escaping @Sendable (Logger.Log) -> Logger.Log.PayloadValidation?
        ) {
            self.channelID = channelID
            self.provider = provider
        }
    }

    private let logger: LoggerRegistable
    private let channelManager: ChannelManager
    private let subsystem: String
    private let payloadValidationConfiguration: PayloadValidationConfiguration?

    public static var logStream: AsyncStream<Logger.Log> {
        LogPublisher.shared.getStream()
    }

    public static let shared = Logger()

    public init(logger: LoggerRegistable = LoggerRepository.shared,
                channelManager: ChannelManager = ChannelManager(),
                subsystem: String = "com.LogSee.logs",
                payloadValidationConfiguration: PayloadValidationConfiguration? = nil) {
        self.logger = logger
        self.channelManager = channelManager
        self.subsystem = subsystem
        self.payloadValidationConfiguration = payloadValidationConfiguration
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
        Task { [logger, subsystem, payloadValidationConfiguration] in
            let payloadValidation = Self.resolvePayloadValidation(
                for: log,
                configuration: payloadValidationConfiguration
            )
            let validatedLog = Logger.Log(
                id: log.id,
                message: log.message,
                channel: log.channel,
                env: log.env,
                level: log.level,
                date: log.date,
                payloadValidation: payloadValidation ?? log.payloadValidation
            )
            let timestamp = Date().formatted(date: .numeric, time: .standard)
            let logMessage = "[\(validatedLog.channel.title.uppercased())] [\(timestamp)] \(validatedLog.message)"

            // 🖥 Print to os.Logger (Xcode console with filters)
            os.Logger(subsystem: subsystem, category: validatedLog.channel.title)
                .log("\(logMessage, privacy: .public)")

            // 📦 Store in repository
            await logger.add(validatedLog)

            LogPublisher.shared.send(validatedLog)
        }
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

private extension Logger {
    static func resolvePayloadValidation(
        for log: Logger.Log,
        configuration: PayloadValidationConfiguration?
    ) -> Logger.Log.PayloadValidation? {
        guard let configuration else { return nil }
        if let channelID = configuration.channelID, channelID != log.channel.id {
            return nil
        }
        return configuration.provider(log)
    }
}
