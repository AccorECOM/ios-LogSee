import Foundation
import Logger
import SwiftUI

extension LogNotificationView {
    struct NotificationRow: View {
        let log: Logger.Log

        var body: some View {
            HStack(alignment: .top, spacing: 10) {
                // Indicateur de canal
                Text(log.channel.emoji)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.top, 5)

                VStack(alignment: .leading, spacing: 4) {
                    // Header with channel
                    Text(log.channel.title.capitalized)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue)

                    // Message
                    Text(log.message)
                        .font(.system(size: 13))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 4)
        }
    }
}
