//
//  UserList.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI

extension User {
    struct List: View {
        let users: Users
    }
}

extension User.List {
    var body: some View {
        VStack{
            ForEach(users, id: \.id) { user in
                User.Cell(user: user)
                    .padding()
                Divider()
            }
        }
    }
}

#Preview {
    User.List(users: User.examples())
}
