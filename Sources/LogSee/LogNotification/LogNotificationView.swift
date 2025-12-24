import Foundation
import Logger
import SwiftUI

public struct LogNotificationView: View {
    let interactor: LogNotificationInteractorInput
    @StateObject var presenter: Presenter

    init(interactor: LogNotificationInteractorInput,
         presenter: Presenter) {
        self.interactor = interactor
        _presenter = StateObject(wrappedValue: presenter)
    }
}

public extension LogNotificationView {
    var body: some View {
        Group {
            if #unavailable(iOS 17), presenter.logs.isEmpty {
                EmptyView()
            } else {
                listView
            }
        }
        .task {
            await interactor.startMonitoring()
        }
    }

    private var listView: some View {
        List {
            ForEach(presenter.logs, id: \.id) { notification in
                NotificationRow(log: notification)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .padding(.top, 50)
        .listRowBackground(Color.clear)
        .task {
            await interactor.startMonitoring()
        }
    }
}

#if DEBUG
#Preview {
    LogNotificationView(interactor: LogNotificationInteractorInputMock(),
                        presenter: .init())
}
#endif
