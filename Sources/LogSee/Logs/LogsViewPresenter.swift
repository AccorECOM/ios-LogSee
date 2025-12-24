import Foundation
import Logger

extension LogsView {
    @MainActor
    public class Presenter: ObservableObject {
        var interactor: LogsInteractorInput?

        @Published var logs: [LogChannel: [Logger.Log]] = [:]
        @Published var filters: [LogChannel] = []
        @Published var currentFilter: LogChannel = .error
        @Published var liveStreamIsEnable: Bool = false
        @Published var enabledLiveStreamChannels: [LogChannel] = []
        @Published var showingChannelSelector: Bool = false

        public init() {}

        func isChannelEnabled(_ channel: LogChannel) -> Bool {
            enabledLiveStreamChannels.contains(channel)
        }

        func clearLogs(for channel: LogChannel) {
            logs[channel] = []
        }
    }
}

extension LogsView.Presenter: LogsInteractorOutput {
    func setLiveStream(_ channel: LogChannel?) async {
        guard self.liveStreamIsEnable else {
            return
        }

        // Only apply livestream for enabled channels
        guard let channel, enabledLiveStreamChannels.contains(channel) else {
            return
        }
    }

    func setFiltres(_ filters: [LogChannel]) async {
        self.filters = filters.sorted()
        if let first = self.filters.first {
            self.currentFilter = first
        }
    }

    func setHistory(_ logs: [LogChannel: [Logger.Log]]) {
        self.logs = logs
    }

    func updateLiveStreamState(isEnabled: Bool, enabledChannels: [LogChannel]) async {
        self.liveStreamIsEnable = isEnabled
        self.enabledLiveStreamChannels = enabledChannels
    }
}
