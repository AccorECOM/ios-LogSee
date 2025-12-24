import Combine
import Foundation
import Logger

extension LogNotificationView {
    struct Interactor {
        private let output: LogNotificationInteractorOutput
        private let dependencies: Dependencies
        private let dataStore: DataStore

        init(output: any LogNotificationInteractorOutput, dependencies: Dependencies) {
            self.output = output
            self.dependencies = dependencies
            self.dataStore = DataStore()
        }
    }
}

extension LogNotificationView.Interactor: LogNotificationInteractorInput {
    func startMonitoring() async {
        let task = Task { @MainActor in
            for await event in Logger.logStream where LiveStreamUseCase.shouldStreamChannel(event.channel) {
                await output.showNotification(log: event)
            }
        }
        await dataStore.setMonitoringTask(task)
    }

    func stopMonitoring() async {
        await dataStore.stopMonitoring()
    }
}

extension LogNotificationView.Interactor {
    struct Dependencies: Sendable {
        var logger: Logger
    }
}
