//
//  TimeCountView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/4/22.
//

import SwiftUI

struct TimeCountView: View {
    
    @Binding var isTimerRunning : Bool
    @State private var startTime =  Date()
    @State var interval = TimeInterval()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(interval.format(using: [.hour, .minute, .second]))
            .font(.system(size: 8, weight: .medium, design: .default))
            .foregroundColor(Color.white)
            .onReceive(timer) { _ in
                if self.isTimerRunning {
                    interval = Date().timeIntervalSince(startTime)
                }
            }
             .onAppear() {
                 if !isTimerRunning {
                     startTime = Date()
                 }
                 isTimerRunning.toggle()
             }
    }
    
}

//struct TimeCountView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeCountView()
//    }
//}
