//
//  HideKeyboard.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/11/22.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
