import Foundation
import Logger

protocol LogsInteractorOutput: Sendable {
    func setHistory(_ logs: [LogChannel: [Logger.Log]]) async
    func setFiltres(_ filters: [LogChannel]) async
    func setLiveStream(_ channel: LogChannel?) async
    func updateLiveStreamState(isEnabled: Bool, enabledChannels: [LogChannel]) async
}
