import Foundation

public struct LogEvent: Sendable {
    public let log: Logger.Log
    public let channel: LogChannel
}
