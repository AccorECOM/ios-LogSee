//
//  ContentView.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI

extension App {
    struct MemberDetails: View {
        let user: User
    }
}

extension App.MemberDetails {
    var body: some View {
        VStack {
            User.Details(user: user)
        }
        .navigationTitle("Users")
    }
}

#Preview {
    NavigationStack {
        App.MemberDetails(user: .example())
    }
}
