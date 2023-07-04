//
//  AuthenticationCode.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/18/22.
//

import SwiftUI

struct AuthenticationCode: View {
   
    
    @State var labelName = ""
    @State var placeholder = "0000"
    @State var text = ""
    var colors: ConstantColors
    var body: some View {
        
        VStack(alignment: .trailing, spacing: 1) {
            
            Text(labelName)
                .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                .font(.system(size: 15, weight: .semibold, design: .default))
                .padding(.trailing, 10)
            
            HStack(spacing: 5){
                
                GreenFunctionButton(buttonText: "ثبت کد", isAnimated: .constant(false))
                    .frame(width: 137, height: 48)
                
                ZStack {
                    HStack {
                        
                        
                        Text("30 ثانیه")
                            .foregroundColor(colors.greenColor)
                            
                        
                        TextField(placeholder, text: $text)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(width: 100, height: 48, alignment: .center)
                        

                    }
                   
                }
                .frame(width: 179, height: 48)
                .border(Color.gray)
                .padding()
            }
            

        }
        
        
    }
    
}

struct AuthenticationCode_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationCode(colors: ConstantColors())
    }
}
