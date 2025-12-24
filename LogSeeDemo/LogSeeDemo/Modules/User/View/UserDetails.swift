//
//  UserRow.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI

extension User {
    struct Details: View {
        let user: User
    }
}

extension User.Details {
    var body: some View {
        VStack {
            Text("ID: \(user.id)")
            Text("Name: \(user.name)")
            Text("Age: \(user.age)")
        }
    }
}

#Preview {
    User.Cell(user: User.example())
}
