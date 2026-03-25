import Foundation

extension Logger {
    public struct Log: Identifiable, Sendable {
        public struct PayloadValidation: Sendable, Equatable {
            public let eventIdentifier: String
            public let expectedKeys: [String]
            public let missingKeys: [String]

            public var isComplete: Bool {
                missingKeys.isEmpty
            }

            public init(
                eventIdentifier: String,
                expectedKeys: [String],
                missingKeys: [String]
            ) {
                self.eventIdentifier = eventIdentifier
                self.expectedKeys = expectedKeys
                self.missingKeys = missingKeys
            }
        }

        public let id: UUID
        public let level: Level
        public let channel: LogChannel
        public let date: Date
        public let message: String
        public let env: [String: any Sendable]
        public let payloadValidation: PayloadValidation?

        public init(
            id: UUID = UUID(),
            message: String,
            channel: LogChannel,
            env: [String: any Sendable] = [:],
            level: Level = .debug,
            date: Date = Date(),
            payloadValidation: PayloadValidation? = nil
        ) {
            self.id = id
            self.date = date
            self.message = message
            self.channel = channel
            self.env = env
            self.level = level
            self.payloadValidation = payloadValidation
        }
    }
}
