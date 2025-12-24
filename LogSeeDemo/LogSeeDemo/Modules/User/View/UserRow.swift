//
//  UserRow.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI

extension User {
    struct Cell: View {
        @Environment(\.onTapUser) var onTap: ((User) -> Void)?
        
        let user: User
    }
}

extension User.Cell {
    var body: some View {
        HStack {
            Text("\(user.name) (\(user.id))")
            Spacer()
        }
        .onTapGesture {
            onTap?(user)
        }
    }
}

#Preview {
    User.Cell(user: User.example())
}
