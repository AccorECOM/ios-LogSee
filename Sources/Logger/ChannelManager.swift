import Foundation

public actor ChannelManager {
    private var availableChannels: [LogChannel] = LogChannel.defaultChannels

    public init() {}

    public func configure(channels: [LogChannel]) {
        availableChannels = channels
    }

    public func getChannels() -> [LogChannel] {
        availableChannels
    }

    public func getChannel(id: String) -> LogChannel? {
        availableChannels.first { $0.id == id }
    }
}
