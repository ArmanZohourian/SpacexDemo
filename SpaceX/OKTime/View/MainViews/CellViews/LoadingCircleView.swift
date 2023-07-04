//
//  LoadingCircleView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/16/22.
//

import SwiftUI

struct LoadingCircleView: View {
    
    @State var progressValue : Float = 0.0
    
    var body: some View {
        VStack {
            
            CustomProgressView(progress: self.$progressValue)
                .frame(width: 25, height: 25)
                .onAppear {
                    self.progressValue = 0.30
                }
            
        }
    }
}

struct CustomProgressView: View {
    
    @Binding var progress: Float
    var color: Color = Color(red: 0 / 255, green: 223 / 255, blue: 150 / 255, opacity: 1)
    var blueColor: Color = Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255)
    
    var body: some View {
        
        
        ZStack {
            
            

            Circle()
                .stroke(lineWidth: 2)
                .opacity(1)
                .foregroundColor(blueColor)
                .frame(width: 37, height: 37)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .square, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 0.5))
                .frame(width: 18.57, height: 18.57)
                .padding(30)
                
        }
        
    }
    }



struct LoadingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCircleView()
    }
}
