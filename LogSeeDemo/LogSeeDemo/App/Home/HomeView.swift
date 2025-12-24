//
//  ContentView.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI

extension App {
    struct HomeView: View {
        @Environment(App.Coordinator.self) private var coordinator
        @State private var viewModel: ViewModel = ViewModel()
        
        private var interactor: Interactor {
            Interactor(coordinator: coordinator,
                       viewModel: viewModel)
        }
    }
}

extension App.HomeView {
    var body: some View {
        ScrollView {
            User.List(users: viewModel.members)
                .environment(\.onTapUser) { user in
                    interactor.routeToMemberDetails(user)
                }
        }
        .task {
            await interactor.fetchUsers()
        }
        .padding()
        .navigationTitle("Home")
    }
}

#Preview {
    App.HomeView()
}
