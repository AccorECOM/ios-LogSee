import Logger
import SwiftUI

extension LogsView.LogRow {
    struct Summary: View {
        let log: Logger.Log
        let channel: LogChannel
        let isExpanded: Bool

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // Channel indicator
                Circle()
                    .fill(log.level.color)
                    .frame(width: 10, height: 10)
                    .padding(.top, 6)

                VStack(alignment: .leading, spacing: 6) {
                    // Header with date and channel
                    HStack {
                        Text(formatTime(log.date))
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(channel.emoji + " " + channel.title.capitalized)
                            .font(.caption)
                            .foregroundColor(log.level.color)
                            .fontWeight(.semibold)
                    }

                    // Message
                    Text(log.message)
                        .font(.system(size: 15))
                        .foregroundColor(.primary)
                        .lineLimit(isExpanded ? nil : 2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                // Expand/collapse indicator
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
                    .padding(.top, 2)
            }
            .contentShape(Rectangle())
        }
    }
}

extension LogsView.LogRow.Summary {
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
