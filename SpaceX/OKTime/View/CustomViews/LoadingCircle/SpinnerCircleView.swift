//
//  SpinnerCircleView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/13/22.
//

import SwiftUI

struct SpinnerCircleView: View {
    
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    
    var body: some View {
        
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .fill(Color.black)
            .rotationEffect(rotation)
        
    }
}
//
//struct SpinnerCircleView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpinnerCircleView()
//    }
//}
