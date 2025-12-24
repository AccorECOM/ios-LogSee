import Foundation
import Logger

public protocol LogsInteractorInput: Sendable {
    func retrieve() async
    func setLiveStream(isEnabled: Bool) async
    func clearLogs() async
    func updateChannelLiveStreamState(channel: LogChannel, isEnabled: Bool) async
    func updateLiveStreamChannels(channels: [LogChannel]) async
    func getLiveStreamState() async -> (isEnabled: Bool, channels: [LogChannel])
}

#if DEBUG
public struct LogsInteractorInputMock: LogsInteractorInput {
    public init() {}
    public func retrieve() async {}
    public func setLiveStream(isEnabled: Bool) async {}
    public func clearLogs() async {}
    public func updateChannelLiveStreamState(channel: LogChannel, isEnabled: Bool) async {}
    public func updateLiveStreamChannels(channels: [LogChannel]) async {}
    public func getLiveStreamState() async -> (isEnabled: Bool, channels: [LogChannel]) {
        (false, [])
    }
}
#endif
