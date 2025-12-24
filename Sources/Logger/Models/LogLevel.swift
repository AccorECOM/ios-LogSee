import Foundation
import SwiftUI

extension Logger.Log {
    public enum Level: Codable, Hashable, Sendable {
        case error, warning, info, debug

        public var color: Color {
            switch self {
            case .error:
                return Color.red
            case .warning:
                return Color.orange
            case .info:
                return Color.blue
            case .debug:
                return Color.green
            }
        }
    }
}
