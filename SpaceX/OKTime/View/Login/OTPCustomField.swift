//
//  OTPCustomField.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/31/22.
//

import SwiftUI

struct OTPCustomField: View {
    
    @FocusState var activeField: OTPFieldState?
    
    @EnvironmentObject var otpViewModel: OTPViewModel
    
    var colors: ConstantColors
    
    var body: some View {
       OTPField()
            .frame(width: UIScreen.screenWidth - 80, alignment: .center)
            .onChange(of: otpViewModel.otpFields) { newValue in
                OTPCondition(value: newValue)
            }
    }
    
    
    @ViewBuilder
    func OTPField() -> some View {
        HStack(spacing: 14) {
            ForEach(0..<4, id: \.self) {index in
                
                VStack {
                    TextField("", text: $otpViewModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .aspectRatio(contentMode: .fill)
                        .focused($activeField, equals: activeStateForIndex(index: index))
                    
                }
                
                .frame(width: 60)
                .frame(height: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(colors.blueColor, lineWidth: 0.5)
                }
                

           
            }
        }
        .frame(height: 60)
    }
    
    func OTPCondition(value: [String]) {
        for index in 0..<4 {
            
            
            //Moving to next Field if current field is done
            for index in 0..<3 {
                if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                    activeField = activeStateForIndex(index: index + 1)
                }
            }
            
            //Moving back is remover
            for index in 1...3 {
                if value[index].isEmpty && !value[index - 1].isEmpty {
                    activeField = activeStateForIndex(index: index - 1)
                }
            }
            
            //if the value is filled then changing it to the last input
            if value[index].count > 1 {
                otpViewModel.otpFields[index] = String(value[index].last!)
            }
        }
    }
    

    
    
    func activeStateForIndex(index: Int) -> OTPFieldState {
        
        switch index {
        case 0:
            return .field1
        case 1:
            return .field2
        case 2:
            return .field3
        case 3:
            return .field4
            
        default:
            return .field4
        }
    
    }
    
    
}


enum OTPFieldState {

case field1
case field2
case field3
case field4

}
