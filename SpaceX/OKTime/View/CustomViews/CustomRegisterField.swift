//
//  CustomRegisterField.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/19/23.
//

import SwiftUI

struct CustomRegisterField: View {

    var colors: ConstantColors
    @State var labelName = ""
    @State var placeholder = "Text"
    @Binding var text : String
    @Binding var errorMessage: String
    @Binding var hasError: Bool
    @State var isPassword : Bool = false
    var body: some View {
        
        
        VStack(alignment: .trailing, spacing: -10) {
            
            Text(labelName)
                .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                .font(.custom("YekanBakhNoEn-Bold", size: 14))
                .padding()
                .offset(x: 10)
                
                
            ZStack {
                if isPassword {
                    SecureField(placeholder, text: $text)
                        .font(.custom("YekanBakhNoEn-Regular", size: 13))
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.screenWidth - 20 , height: 50, alignment: .center)
                        .cornerRadius(10)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.custom("YekanBakhNoEn-Regular", size: 13))
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.screenWidth - 20 , height: 50, alignment: .center)
                        .cornerRadius(10)
                }

            }
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(colors.lightGrayColor, lineWidth: 0.5)
            )
            
            
            Text(errorMessage)
                .font(.custom("YekanBakhNoEn-Bold", size: 11))
                .foregroundColor(Color.red)
                .opacity(hasError ? 1.0 : 0.0)
                .padding(.trailing, 0)
                .padding(.top, 13)
                
            
            
            
        }
        .onChange(of: text) { newValue in
            hasError = false
        }
        
        
    }
    
    
    
}

