//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/27/23.
//

import SwiftUI

@main
struct SpaceXApp: App {
    
    
    @StateObject var homeViewModel = ShuttleViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(homeViewModel)

                ZStack {
                    if homeViewModel.isShwoingLaunchScreen {
                        SplashView()
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
