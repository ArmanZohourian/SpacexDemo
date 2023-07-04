//
//  UserRegisterView.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI

struct CustomTextField: View {
    
    var colors: ConstantColors
    @State var labelName = ""
    @State var optionalText = ""
    @State var placeholder = "Text"
    @Binding var text : String
    @State var isPassword : Bool = false
    @State var isOptional = false
    var body: some View {
        
        
        VStack(alignment: .trailing, spacing: -10) {
            
            
            HStack(spacing: -20) {
                
                Text("(\(optionalText))")
                    .foregroundColor(colors.tirratyColor)
                    .font(.custom("YekanBakhNoEn-Mixed", size: 10))
                    .opacity(isOptional ? 1.0 : 0.0)
                    
                
                Text(labelName)
                    .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                    .font(.custom("YekanBakhNoEn-Bold", size: 14))
                    .padding()
                    .offset(x: 10)
                    
 
            }
                
            ZStack {
                if isPassword {
                    SecureField(placeholder, text: $text)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.screenWidth - 20 , height: 50, alignment: .center)
                        .cornerRadius(10)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
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
            
        }
        
        
    }
}
