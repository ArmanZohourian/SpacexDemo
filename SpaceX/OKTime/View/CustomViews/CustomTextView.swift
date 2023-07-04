//
//  CustomTextView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/10/22.
//

import SwiftUI

struct CustomTextView: View {
    var text: String = ""
    var colors: ConstantColors
    var labelName : String = ""
    var body: some View {

            
            VStack(alignment: .trailing, spacing: 1) {
                
                Text(labelName)
                    .foregroundColor(colors.blueColor)
                    .font(.custom("YekanBakhNoEn-Bold", size: 14))
                    .padding()
//                    .offset(x: 10)
                
                
                
                ZStack(alignment: .trailing) {
                    Rectangle()
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.screenWidth - 20 , height: 50, alignment: .center)
                    .cornerRadius(10)
                    .border(colors.lightGrayColor)
                    
                    Text(text)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.gray)
                }
            }
            
            
        
    }
}
//
//struct CustomTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextView()
//    }
//}
