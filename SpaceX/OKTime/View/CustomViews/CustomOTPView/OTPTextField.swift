//
//  testView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/12/22.
//

import SwiftUI

struct OTPTextField: View {
    @StateObject var otpViewModel : OTPViewModel = .init()
    @FocusState var activeField: OTPField? 
    var body: some View {
        
        
                VStack {
                    OTPField()
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
            .onChange(of: otpViewModel.otpFields) { newValue in
                OTPCondition(value: newValue)
            }
        
    }
    
    //MARK: OTP Functionality
    
    
    func OTPCondition(value: [String]) {
        
        //Moving forward if one is filled
        for index in 0..<3 {
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index + 1 )
            }
        }
        
        //Moving bakcwards
        for index in 1..<4 {
            if value[index].count == 0 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        
        //Making the last input in the otp box the only one
        for index in 0..<4 {
            if value[index].count > 1 {
                otpViewModel.otpFields[index] = String(value[index].last!)
            }
        }
    }
    
    //MARK: OTP View
    
    @ViewBuilder
    func OTPField2() -> some View{
        ZStack {
        }
    }
    
    
    
    
    @ViewBuilder
    func OTPField() -> some View{
        HStack(spacing: 14) {
            ForEach(0..<4,id: \.self) { index in
                ZStack {
                    Image("OTPRectangle")
                    VStack(spacing: 8) {
                        TextField("", text: $otpViewModel.otpFields[index])
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .multilineTextAlignment(.center)
                            .focused($activeField, equals: activeStateForIndex(index: index))
                    }
                    .frame(width: 40)
                }
                
            }
        }
    }
    
    func activeStateForIndex(index: Int) -> OTPField {
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        default: return .field4
        }
    }
    
    
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextField()
    }
}

enum OTPField {
    case field1
    case field2
    case field3
    case field4
}
