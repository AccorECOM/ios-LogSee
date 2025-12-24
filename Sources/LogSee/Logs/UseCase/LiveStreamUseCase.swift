import Foundation
import Logger

struct LiveStreamUseCase {

    enum Constants {
        static let liveStreamEnabledKey = "DEBUG_liveStreamIsEnable"
        static let enabledChannelsKey = "DEBUG_enabledLiveStreamChannels"
    }

    static func getLiveStreamChannels() -> [LogChannel] {
        guard let savedChannels = UserDefaults.standard.array(forKey: Constants.enabledChannelsKey) as? [Data] else {
            return []
        }

        return savedChannels.compactMap { data in
            try? JSONDecoder().decode(LogChannel.self, from: data)
        }
    }

    static func isLiveStreamEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: Constants.liveStreamEnabledKey)
    }

    static func shouldStreamChannel(_ channel: LogChannel) -> Bool {
        guard isLiveStreamEnabled() else { return false }
        return getLiveStreamChannels().contains(channel)
    }

    static func enableLiveStream(channels: [LogChannel]) {
        let encodedChannels = channels.compactMap { channel -> Data? in
            try? JSONEncoder().encode(channel)
        }
        UserDefaults.standard.set(encodedChannels, forKey: Constants.enabledChannelsKey)
        UserDefaults.standard.set(true, forKey: Constants.liveStreamEnabledKey)
    }

    static func disableLiveStream() {
        UserDefaults.standard.set(false, forKey: Constants.liveStreamEnabledKey)
    }
}
