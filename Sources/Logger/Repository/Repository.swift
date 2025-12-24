import Foundation

public protocol LoggerRegistable: Sendable {
    func add(_ log: Logger.Log) async
    func get(for channel: LogChannel) async -> [Logger.Log]
    func getAll() async -> [LogChannel: [Logger.Log]]
    func getChannels() async -> Set<LogChannel>
    func clear(for channel: LogChannel?) async
}

public actor LoggerRepository: LoggerRegistable {
    private var logs: [LogChannel: [Logger.Log]] = [:]
    public static let shared = LoggerRepository()
    public init() {}

    public func add(_ log: Logger.Log) {
        if logs[log.channel] == nil {
            logs[log.channel] = []
        }
        logs[log.channel]?.insert(log, at: 0)
    }

    public func get(for channel: LogChannel) -> [Logger.Log] {
        logs[channel] ?? []
    }

    public func getAll() -> [LogChannel: [Logger.Log]] {
        logs
    }

    public func getChannels() async -> Set<LogChannel> {
        Set(logs.keys)
    }

    public func clear(for channel: LogChannel? = nil) {
        if let channel {
            logs[channel] = []
            return
        }

        logs.removeAll()
    }
}
