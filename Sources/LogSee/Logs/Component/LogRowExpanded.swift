import Logger
import SwiftUI

extension LogsView.LogRow {
    struct Expanded: View {
        let log: Logger.Log

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Divider()
                    .padding(.horizontal, 16)

                // Full date and time
                HStack {
                    Text("Timestamp:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    Text(formatFullDate(log.date))
                        .font(.subheadline)
                }
                .padding(.horizontal, 16)

                if let payloadValidation = log.payloadValidation {
                    payloadValidationSection(payloadValidation)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                }

                // Environment variables section
                if !log.env.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Environment Variables")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.top, 4)

                        // Environment variables table
                        VStack(alignment: .leading, spacing: 0) {
                            envList
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .padding(.bottom, 16)
        }
    }
}

extension LogsView.LogRow.Expanded {
    var envList: some View {
        ForEach(log.env.keys.sorted(), id: \.self) { key in
            if let value = log.env[key] {
                HStack(alignment: .top) {
                    Text(key)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)

                    Text(String(describing: value))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .padding(.bottom, 4)
            }
        }
    }

    @ViewBuilder
    func payloadValidationSection(_ payloadValidation: Logger.Log.PayloadValidation) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Payload Validation")
                .font(.headline)
                .foregroundColor(.primary)

            HStack {
                Text("Status")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(payloadValidation.isComplete ? "Complete" : "Incomplete")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(payloadValidation.isComplete ? .green : .orange)
            }

            if !payloadValidation.missingKeys.isEmpty {
                Text("Missing fields")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ForEach(payloadValidation.missingKeys, id: \.self) { key in
                    Text(key)
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(.orange)
                        .padding(.vertical, 2)
                }
            }
        }
    }
}

extension LogsView.LogRow.Expanded {
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
