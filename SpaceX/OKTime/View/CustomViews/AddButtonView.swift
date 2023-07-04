//
//  AddButtonView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI

struct AddButtonView: View {
    
    var buttonText : String
    var colors: ConstantColors
    
    var body: some View {

        HStack(spacing: 10) {
            
            Text(buttonText)
                .foregroundColor(colors.whiteColor)
            Text("+")
                .foregroundColor(colors.whiteColor)
            
        }
        .frame(width: UIScreen.screenWidth - 20 , height: 50)
        .background(
            colors.blueColor
        )
        .cornerRadius(7)
    }
}
//
//struct AddButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddButtonView(colors: ConstantColors())
//    }
//}
