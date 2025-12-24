import Foundation

extension Logger {
    public struct Log: Identifiable, Sendable {
        public let id: UUID
        public let level: Level
        public let channel: LogChannel
        public let date: Date
        public let message: String
        public let env: [String: any Sendable]

        public init(
            message: String,
            channel: LogChannel,
            env: [String: any Sendable] = [:],
            level: Level = .debug,
            date: Date = Date()
        ) {
            self.id = UUID()
            self.date = date
            self.message = message
            self.channel = channel
            self.env = env
            self.level = level
        }
    }
}
