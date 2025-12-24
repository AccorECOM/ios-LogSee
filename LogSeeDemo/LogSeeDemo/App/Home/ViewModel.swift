//
//  ViewModel.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import Foundation
import LogSee
import Logger

extension App.HomeView {
    @Observable
    class ViewModel {
        var members: Users = []
    }
}

extension App.HomeView.ViewModel: ViewModelInput {
    func setMembers(_ members: Users) {
        self.members = members
        Logger.shared.log("Home - ViewModel.setMembers", channel: .info)
    }
}

protocol ViewModelInput {
    func setMembers(_ members: Users)
}
