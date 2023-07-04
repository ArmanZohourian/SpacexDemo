//
//  LaunchScreenStateManager.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/2/23.
//

import Foundation
import SwiftUI

class LaunchScreenStateManager: ObservableObject {
    
    @Published private(set) var isShwoingLaunchScreen = true
    
    func dismissLaunchScreen() {
        isShwoingLaunchScreen = false
    }
}
