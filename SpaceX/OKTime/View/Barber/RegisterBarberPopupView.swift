//
//  RegisterBarberPopupView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/18/22.
//

import SwiftUI

struct RegisterBarberPopupView: View {
    
    var colors: ConstantColors
    @State var firstName: String = ""
    var body: some View {
        
        VStack {
            
            HStack(spacing: 220) {
                
                Button {
                    //Sing
                    print("Close the popup")
                } label: {
                    Image("close-circle")
                }

                Text("افزودن آرایشگر ")
                
            }
            
            VStack {
                CustomTextField(colors: colors, labelName: "نام و نام خانوادگی", placeholder: "به نام مثال علی", text: $firstName)
//                PhonenumberView()
                AuthenticationCode(labelName: "کد احراز هویت", placeholder: "0000", colors: ConstantColors())
                
            }
            
            
            
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 425)
    }
}

