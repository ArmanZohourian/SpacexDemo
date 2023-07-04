//
//  TimeIntervalView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import SwiftUI

struct CountDownView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    @Binding var timeRemaining : Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        
        ZStack {
            VStack {
                Text("00:\(timeRemaining)")
                    .opacity(timeRemaining == 0 ? 0.0 : 1.0)
            }
        }
        .onReceive(timer) { time in
                
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                isActive = true
            } else {
                isActive = false
            }
        }
    }
}
