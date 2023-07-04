//
//  OTPView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/12/22.
//

import SwiftUI

struct OTPView2: View {
    @StateObject var otpViewModel : OTPViewModel = .init()
    var body: some View {
        
        VStack {
            OTPField()
        }
        .navigationTitle("Verification")
        
    }
    
    
    @ViewBuilder
    func OTPField() -> some View{
        HStack(spacing: 14) {
            ForEach(0..<4,id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $otpViewModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                    
                }
                .frame(width: 40)
            }
        }
    }
    
    
}

struct OTPView2_Previews: PreviewProvider {
    static var previews: some View {
        OTPView2()
    }
}
