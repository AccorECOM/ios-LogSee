import Foundation
import Logger
import SwiftUI

extension LogNotificationView {
    struct NotificationRow: View {
        let log: Logger.Log

        var body: some View {
            HStack(alignment: .top, spacing: 8) {
                // Indicateur de canal
                Text(log.channel.emoji)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 2) {
                    // Header with channel
                    Text(log.channel.title.capitalized)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue)

                    // Message
                    Text(log.message)
                        .font(.system(size: 13))
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    if let payloadValidation = log.payloadValidation, !payloadValidation.isComplete {
                        Label("Missing \(payloadValidation.missingKeys.count) field(s)", systemImage: "exclamationmark.triangle.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 12)
        }
    }
}
