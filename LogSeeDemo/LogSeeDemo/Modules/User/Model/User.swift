//
//  User.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import Foundation
import Logger

typealias Users = [User]
struct User: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let age: Int
}

extension User {
    static func examples() -> [User] {
        Logger.shared.log("Home - examples users", channel: .database, env: [
            "latence": "250ms",
            "count": "3",
            "status": "success",
            "bdd_version": "1.0.0"
        ])
        return [
            User(id: "1", name: "Orka", age: 28),
            User(id: "2", name: "Kalle", age: 25),
            User(id: "3", name: "Petter", age: 30),
        ]
    }
    
    static func example() -> User {
        Logger.shared.log("Home - example user", channel: .database)
        return User(id: "1", name: "Orka", age: 28)
    }
}
