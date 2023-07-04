//
//  Binding.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/21/22.
//

import Foundation
import SwiftUI
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
