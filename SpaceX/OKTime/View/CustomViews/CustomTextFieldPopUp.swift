//
//  CustomTextFieldPopUp.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/12/22.
//

import SwiftUI

struct CustomTextFieldPopUp: View {
    var colors: ConstantColors
    @State var labelName = ""
    @State var placeholder = "Text"
    @Binding var text : String
    @State var isPassword : Bool = false
    var body: some View {
        
        
        VStack(alignment: .trailing, spacing: 0) {
            
            Text(labelName)
                .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                .font(.system(size: 15, weight: .semibold, design: .default))
                .padding()
                .offset(x: 10)
                
            ZStack {
                if isPassword {
                    SecureField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.screenWidth - 40 , height: 50, alignment: .center)
                        .cornerRadius(10)
                        
                } else {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.screenWidth - 40 , height: 50, alignment: .center)
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

struct CustomTextFieldPopUp_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldPopUp(colors: ConstantColors(), text: .constant(""))
    }
}
