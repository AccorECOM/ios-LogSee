import Logger
import SwiftUI

struct ChannelSelectorSheet: View {
    @ObservedObject var presenter: LogsView.Presenter
    let interactor: LogsInteractorInput
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                // Live Stream Toggle at the top
                HStack {
                    Toggle(isOn: Binding(
                        get: { presenter.liveStreamIsEnable },
                        set: { newValue in
                            Task {
                                await interactor.setLiveStream(isEnabled: newValue)
                            }
                        }
                    )) {
                        HStack {
                            Image(systemName: presenter.liveStreamIsEnable ? "dot.radiowaves.left.and.right" : "radiowaves.left")
                                .foregroundColor(presenter.liveStreamIsEnable ? .green : .red)
                            Text("Live Stream")
                                .font(.headline)
                        }
                    }
                    .toggleStyle(.switch)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, 8)

                // List of channels
                List {
                    Section(header: Text("Select channels for live streaming")) {
                        ForEach(presenter.filters, id: \.self) { channel in
                            HStack {
                                Text(channel.title.capitalized)
                                    .font(.body)

                                Spacer()

                                Toggle("", isOn: Binding(
                                    get: { presenter.isChannelEnabled(channel) },
                                    set: { newValue in
                                        Task {
                                            await interactor.updateChannelLiveStreamState(channel: channel, isEnabled: newValue)
                                        }
                                    }
                                ))
                                .labelsHidden()
                                .disabled(!presenter.liveStreamIsEnable)
                            }
                        }
                    }
                }
                #if os(iOS)
                .listStyle(.insetGrouped)
                #else
                .listStyle(.inset)
                #endif
            }
            .navigationTitle("Log Channels")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    ChannelSelectorSheet(
        presenter: LogsView.Presenter(),
        interactor: LogsInteractorInputMock()
    )
}
#endif
