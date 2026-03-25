import Foundation
import Logger

// MARK: Dependencies
extension LogsView.Interactor {
    struct Dependencies {
        let logger: Logger
    }
}

extension LogsView {
    struct Interactor {
        private let output: LogsInteractorOutput
        private let logger: Logger

        init(output: LogsInteractorOutput, dependencies: Dependencies) {
            self.output = output
            self.logger = dependencies.logger
        }
    }
}

// MARK: - Input
extension LogsView.Interactor: LogsInteractorInput {
    func clearLogs() async {
        await Logger.shared.clear()
        await retrieve()
    }

    func retrieve() async {
        let data = await logger.getAll()
        await output.setFiltres(Array(data.keys))
        await output.setHistory(data)

        await updateLiveStreamState()
    }

    func setLiveStream(isEnabled: Bool) async {
        if isEnabled {
            LiveStreamUseCase.enableLiveStream(channels: LiveStreamUseCase.getLiveStreamChannels())
        } else {
            LiveStreamUseCase.disableLiveStream()
        }

        await updateLiveStreamState()
    }

    func updateChannelLiveStreamState(channel: LogChannel, isEnabled: Bool) async {
        var updatedChannels = LiveStreamUseCase.getLiveStreamChannels()

        if isEnabled {
            if !updatedChannels.contains(channel) {
                updatedChannels.append(channel)
            }
        } else {
            updatedChannels.removeAll(where: { $0 == channel })
        }

        await updateLiveStreamChannels(channels: updatedChannels)
    }

    func updateLiveStreamChannels(channels: [LogChannel]) async {
        if LiveStreamUseCase.isLiveStreamEnabled() {
            LiveStreamUseCase.enableLiveStream(channels: channels)
        }

        await updateLiveStreamState()
    }

    func getLiveStreamState() async -> (isEnabled: Bool, channels: [LogChannel]) {
        (
            isEnabled: LiveStreamUseCase.isLiveStreamEnabled(),
            channels: LiveStreamUseCase.getLiveStreamChannels()
        )
    }
}

private extension LogsView.Interactor {
    func updateLiveStreamState() async {
        await output.updateLiveStreamState(
            isEnabled: LiveStreamUseCase.isLiveStreamEnabled(),
            enabledChannels: LiveStreamUseCase.getLiveStreamChannels()
        )
    }
}
