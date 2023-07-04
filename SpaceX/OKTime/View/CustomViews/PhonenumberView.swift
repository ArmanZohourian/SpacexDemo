//
//  PhonenumberView.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI

struct PhonenumberView: View {
    
    @Binding var phoneNumber: String
    
    var colors: ConstantColors
    
    var language = LocalizationService.shared.language
    
    var hasDescription: Bool
    
    var description: String
    
    var body: some View {
        
  
            
        VStack(alignment: .trailing, spacing: 5) {
            
            Text("phone_number_label".localized(language))
                .font(.custom("YekanBakhNoEn-Bold", size: 14))
                .foregroundColor(colors.blueColor)
                .padding(.trailing , 5)
                
                
            HStack(spacing: 15) {
                
                
                        Button(action: {
                            //Choose the region number
                        }, label: {
                            
                            //Country Flag
                            HStack(spacing: 15){
                                Image("flag")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                
                                //Multi number picker
                                Text("+98")
                                    .font(.custom("YekanBakhNoEn-Light", size: 15))
                                    .foregroundColor(.gray)
                                
                                Image("arrow-down")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                
                            }
                        })
                        
                        TextField("912 000 00 00", text: $phoneNumber)
                            .foregroundColor(.gray)
                            .keyboardType(.numberPad)
                            .font(.custom("YekanBakhNoEn-Light", size: 15))
                    
                }
            .padding()
            .environment(\.layoutDirection, .leftToRight)
            .frame(width: UIScreen.screenWidth - 20, height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(colors.lightGrayColor, lineWidth: 0.5)
            )
            
            Text(description)
                .foregroundColor(colors.grayColor)
                .font(.custom("YekanBakhNoEn-Regular", size: 14))
                .padding(.trailing)
            }

    }
}
