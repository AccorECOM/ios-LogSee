import Foundation
import SwiftUI

public struct LogChannel: Codable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let emoji: String

    public init(id: String, title: String, emoji: String = "") {
        self.id = id
        self.title = title
        self.emoji = emoji
    }
}

extension LogChannel: Comparable {
    public static func < (lhs: LogChannel, rhs: LogChannel) -> Bool {
        lhs.title < rhs.title
    }
}

// MARK: - Default channels
public extension LogChannel {
    static let network = LogChannel(id: "network", title: "Network", emoji: "🌐")
    static let database = LogChannel(id: "database", title: "Database", emoji: "🗄️")
    static let auth = LogChannel(id: "auth", title: "Authentication", emoji: "🔐")
    static let error = LogChannel(id: "error", title: "Error", emoji: "❌")
    static let debug = LogChannel(id: "debug", title: "Debug", emoji: "🐛")
    static let info = LogChannel(id: "info", title: "Info", emoji: "ℹ️")

    static let defaultChannels: [LogChannel] = [
        .network, .database, .auth, .error, .debug, .info
    ]
}
