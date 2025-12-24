import Foundation
import Logger

protocol LogNotificationInteractorOutput: AnyObject, Sendable {
    func showNotification(log: Logger.Log) async
}
