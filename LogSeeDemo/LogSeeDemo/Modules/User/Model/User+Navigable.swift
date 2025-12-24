//
//  EnvironmentKey.swift
//  LogSeeDemo
//
//  Created by Orka on 2025-11-14.
//

import SwiftUI

extension EnvironmentValues {
   var onTapUser: ((User)->Void)? {
       get {
           self [EnvironmentKey_onTapUser.self]
       }
       set {
           self [EnvironmentKey_onTapUser.self] = newValue
       }
   }

   struct EnvironmentKey_onTapUser: EnvironmentKey {
       static var defaultValue: ((User) -> Void)?
   }
}
