import Foundation

extension Logger {
    public struct LogPublisher: Sendable {
        public static let shared = LogPublisher()

        private let stream: AsyncStream<Logger.Log>
        private var continuation: AsyncStream<Logger.Log>.Continuation?

        public init() {
            var continuationRef: AsyncStream<Logger.Log>.Continuation?
            self.stream = AsyncStream<Logger.Log> { continuation in
                continuationRef = continuation
            }
            self.continuation = continuationRef
        }

        func send(_ event: Logger.Log) {
            continuation?.yield(event)
        }

        public func getStream() -> AsyncStream<Logger.Log> {
            stream
        }
    }
}
