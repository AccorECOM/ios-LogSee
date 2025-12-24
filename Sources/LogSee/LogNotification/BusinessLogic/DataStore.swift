import Combine

extension LogNotificationView.Interactor {
    actor DataStore: Sendable {
        private var monitoringTask: Task<Void, Never>?

        func setMonitoringTask(_ task: Task<Void, Never>?) {
            monitoringTask = task
        }

        func stopMonitoring() {
            monitoringTask?.cancel()
            monitoringTask = nil
        }
    }
}
