//
//  SplashView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/2/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
    
            Color.launchBackground
                .ignoresSafeArea()
        
            Image("spacex")
                .resizable()
                .clipped()
                .frame(width: 250, height: 250)
                .background(Color.red)
        }
        .animation(.default)
    }
}


