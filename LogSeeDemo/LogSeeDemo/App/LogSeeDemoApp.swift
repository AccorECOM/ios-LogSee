//
//  LogSeeDemoApp.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI
import LogSee
import Logger

@main
struct App: SwiftUI.App {

    @State private var coordinator = Coordinator()
    @State private var showLogger = false

    init() {
        Task {
            await Logger.configure(channels: [
                .network, .database, .error, .debug, .info, .routing
            ])
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                HomeView()
                    .navigationDestination(for: Coordinator.Destination.self) { destination in
                        switch destination {
                        case .home:
                            HomeView()
                        case .memberDetails(let user):
                            MemberDetails(user: user)
                        }
                    }
            }
            #if DEBUG
            .task {
                LogSeeModuleFactory.initLogNotificationModule()
            }
            .onShake {
                showLogger = true
            }
            .sheet(isPresented: $showLogger) {
                NavigationStack {
                    LogSeeModuleFactory.makeAnalyticsView()
                }
                .navigationTitle("LogSee")
            }
            #endif
            .environment(coordinator)
        }
    }
}
