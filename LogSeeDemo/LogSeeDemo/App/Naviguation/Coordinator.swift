//
//  Coordinator.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI

extension App {
    @Observable
    class Coordinator {
        var path = NavigationPath()

        func navigate(to destination: Destination) {
            path.append(destination)
        }

        func pop() {
            guard !path.isEmpty else { return }
            path.removeLast()
        }

        func popToRoot() {
            path = NavigationPath()
        }
    }
}

// MARK: - Destinations
extension App.Coordinator {
    enum Destination: Hashable {
        case home
        case memberDetails(User)
    }
}
