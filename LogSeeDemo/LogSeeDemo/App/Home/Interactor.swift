//
//  Interactor.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import Foundation
import Logger

extension App.HomeView {
    struct Interactor {
        private let coordinator: App.Coordinator
        private let viewModel: ViewModelInput

        init(coordinator: App.Coordinator, viewModel: ViewModelInput) {
            self.coordinator = coordinator
            self.viewModel = viewModel
        }
        
        @Sendable
        func fetchUsers() async {
            Logger.shared.log("Home - Fetching users", channel: .network)
            viewModel.setMembers(User.examples())
        }

        // MARK: - User Actions
        func routeToMemberDetails(_ member: User) {
            Logger.shared.log("Home - examples users", channel: .routing, env: [
                "Route": "Member Details"
            ])
            coordinator.navigate(to: .memberDetails(member))
        }
    }
}
