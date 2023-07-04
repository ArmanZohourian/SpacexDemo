//
//  TimerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import SwiftUI

struct TimerView: View {
    
    var colors: ConstantColors
    @Binding var textValue: String
    var isPopup: Bool = false
    var labelText: String = ""
    var logo: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .trailing, spacing: 10) {
                Text(labelText)
                    .font(.custom("YekanBakhNoEn-Bold", size: 14))
                    .padding(.trailing, 10)
                    .foregroundColor(colors.blueColor)
                
                HStack {
                    Text(textValue)
                        .foregroundColor(colors.grayColor)
                    Spacer()
                    Image(logo)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing)
                        
                        
                        
                }
                .frame(width: isPopup ? UIScreen.screenWidth / 2.5 : UIScreen.screenWidth / 2.2, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(colors.lightGrayColor, lineWidth: 0.5)
                )
                
            }
        }
        
        
    }
}
