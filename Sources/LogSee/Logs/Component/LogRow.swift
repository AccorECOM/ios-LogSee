import Logger
import SwiftUI

extension LogsView {
    struct LogRow: View {
        let log: Logger.Log
        let channel: LogChannel
        let isExpanded: Bool
        let onToggle: (Bool) -> Void

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    onToggle(!isExpanded)
                }) {
                    Summary(log: log, channel: channel, isExpanded: isExpanded)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                // Expanded details
                if isExpanded {
                    Expanded(log: log)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isExpanded ? log.level.color.opacity(0.3) : Color.gray.opacity(0.1), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isExpanded)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
        }
    }
}

extension LogsView.LogRow {
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }

    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
