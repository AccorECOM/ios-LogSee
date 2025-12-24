import Foundation
import Logger
import SwiftUI

public struct LogsView: View {
    let interactor: LogsInteractorInput
    @StateObject var presenter: Presenter
    @State private var expandedLogId: UUID?

    public init(interactor: LogsInteractorInput, presenter: Presenter) {
        self.interactor = interactor
        _presenter = StateObject(wrappedValue: presenter)
    }
}

public extension LogsView {
    var body: some View {
        VStack(spacing: 0) {
            filterSelector
                .padding(.bottom, 8)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(presenter.logs[presenter.currentFilter] ?? [], id: \.id) { log in
                        LogRow(log: log,
                               channel: presenter.currentFilter,
                               isExpanded: expandedLogId == log.id,
                               onToggle: { isExpanding in
                                expandedLogId = isExpanding ? log.id : nil
                               })
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HStack(spacing: 16) {
                    clearLogsButton
                    channelSelectorButton
                }
            }
        }
        .sheet(isPresented: $presenter.showingChannelSelector) {
            ChannelSelectorSheet(presenter: presenter, interactor: interactor)
        }
        .task {
            await interactor.retrieve()
        }
    }

    private var channelSelectorButton: some View {
        Button(action: {
            presenter.showingChannelSelector = true
        }) {
            HStack(spacing: 4) {
                Image(systemName: presenter.liveStreamIsEnable ? "dot.radiowaves.left.and.right" : "radiowaves.left")
                    .foregroundColor(presenter.liveStreamIsEnable ? .green : .gray)

                if !presenter.enabledLiveStreamChannels.isEmpty && presenter.liveStreamIsEnable {
                    Text("\(presenter.enabledLiveStreamChannels.count)")
                        .font(.caption)
                        .padding(4)
                        .background(Color.green.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
    }

    private var clearLogsButton: some View {
        Button(action: {
            Task {
                await interactor.clearLogs()
            }
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
    }

    private var filterSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(presenter.filters, id: \.self) { filter in
                    filterButton(for: filter)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color.white)
    }

    private func filterButton(for filter: LogChannel) -> some View {
        Button(action: {
            presenter.currentFilter = filter
        }) {
            Text(filter.title.capitalized)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(presenter.currentFilter == filter ? Color.accentColor : Color.gray.opacity(0.2))
                )
                .foregroundColor(presenter.currentFilter == filter ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut, value: presenter.currentFilter)
    }
}

#if DEBUG
#Preview {
    LogsView(interactor: LogsInteractorInputMock(),
             presenter: .init())
}
#endif
