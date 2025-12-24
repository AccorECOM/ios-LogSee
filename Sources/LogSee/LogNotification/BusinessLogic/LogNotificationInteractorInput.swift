import Foundation
import Logger

public protocol LogNotificationInteractorInput: Sendable {
    func startMonitoring() async
    func stopMonitoring() async
}

#if DEBUG
public struct LogNotificationInteractorInputMock: LogNotificationInteractorInput {
    public init() {}
    public func startMonitoring() async {}
    public func stopMonitoring() async {}
    public func showNotification(log: Logger.Log) async {}
}
#endif
