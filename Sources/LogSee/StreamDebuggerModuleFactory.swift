import Foundation
import Logger
import SwiftUI
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public enum LogSeeModuleFactory {
    @MainActor
    public static func makeAnalyticsView(
        logger: LoggerRegistable = LoggerRepository.shared
    ) -> LogsView {
        let dependencies = LogsView.Interactor.Dependencies(
            logger: Logger(logger: logger)
        )
        let presenter = LogsView.Presenter()
        let interactor = LogsView.Interactor(output: presenter, dependencies: dependencies)
        presenter.interactor = interactor
        return LogsView(interactor: interactor,
                        presenter: presenter)
    }

    @MainActor
    public static func makeLogNotificationView(
        logger: Logger = Logger()
    ) -> LogNotificationView {
        let dependencies = LogNotificationView.Interactor.Dependencies(
            logger: logger
        )
        let presenter = LogNotificationView.Presenter()
        let interactor = LogNotificationView.Interactor(output: presenter, dependencies: dependencies)
        return LogNotificationView(interactor: interactor,
                                   presenter: presenter)
    }

    #if os(iOS) || os(tvOS)
    /// Initialize the log notification module and add it to the main window
    @MainActor
    public static func initLogNotificationModule() {
        #if DEBUG
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        let logNotificationView = makeLogNotificationView()
        let hostingController = UIHostingController(rootView: logNotificationView)

        hostingController.view.backgroundColor = .clear
        hostingController.view.isUserInteractionEnabled = false

        window.addSubview(hostingController.view)
        hostingController.view.frame = window.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.view.layer.zPosition = 9_000
        #endif
    }
    #elseif os(macOS)
    @MainActor
    private static func initLogNotificationModule() {
        guard let window = NSApplication.shared.windows.first,
              let contentView = window.contentView else {
            return
        }

        let logNotificationView = makeLogNotificationView()
        let hostingController = NSHostingController(rootView: logNotificationView)

        hostingController.view.frame = contentView.bounds
        hostingController.view.autoresizingMask = [.width, .height]
        hostingController.view.wantsLayer = true
        hostingController.view.layer?.zPosition = 9_000

        contentView.addSubview(hostingController.view)
    }
    #else
    @MainActor
    private static func initLogNotificationModule() {
        print("Log notification module not available on this platform.")
    }
    #endif
}
