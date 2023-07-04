//
//  SpinnerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/13/22.
//

import SwiftUI

struct SpinnerView: View {
    
    
    
    let rotationTime: Double = 0.75
    let fullRotation: Angle = .degrees(360)
    static let initialDegree: Angle = .degrees(270)
    let animationTime: Double = 1.9
    
    @State var spinnerStart: CGFloat = 0.0
    @State var spinnerEndS1: CGFloat = 0.03
    @State var spinnerEndS2S3: CGFloat = 0.03
    
    @State var rotationDegreeS1 = initialDegree
    @State var rotationDegreeS2 = initialDegree
    @State var rotationDegreeS3 = initialDegree
    
    var body: some View {
        
        ZStack {
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1)

        }
        .onAppear {
            self.animateSpinner()
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { mainTimer in
                self.animateSpinner()
            }
        }
        
    }
    
    
    func animateSpinner(with timeInterval: Double, completion: @escaping(() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: rotationTime)) {
                completion()
            }
        }
    }
    
    func animateSpinner() {
        
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }

        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegreeS1 += fullRotation
            self.spinnerEndS2S3 = 0.8
        }

        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS1 = 0.03
            self.spinnerEndS2S3 = 0.03
        }

        animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreeS2 += fullRotation }

        animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreeS3 += fullRotation }
        
    }
    
}

//struct SpinnerView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpinnerView()
//    }
//}
