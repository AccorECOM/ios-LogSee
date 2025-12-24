import Combine
import Foundation
import Logger
import SwiftUI

extension LogNotificationView {
    @MainActor
    public class Presenter: ObservableObject, LogNotificationInteractorOutput {
        @Published var logs: [Logger.Log] = []
        private let displayDuration: TimeInterval = 3.0

        init() {}

        func showNotification(log: Logger.Log) async {
            withAnimation {
                self.logs.append(log)
            }

            Task.detached(priority: .background) {
                try? await Task.sleep(nanoseconds: UInt64(self.displayDuration * 1_000_000_000))
                await MainActor.run {
                    withAnimation {
                        self.logs.removeAll(where: { $0.id == log.id })
                    }
                }
            }
        }
    }
}
