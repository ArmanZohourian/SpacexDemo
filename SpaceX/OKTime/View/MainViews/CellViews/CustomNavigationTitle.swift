//
//  CustomNavigationTitle.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import SwiftUI

struct CustomNavigationTitle: View {
    
    var name: String
    var logo: String
    var colors: ConstantColors
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            colors.blueColor
            HStack {
                Text(name)
                    .font(.custom("YekanBakhNoEn-Bold", size: 20))
                Image(logo)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.bottom, 10)
            .padding(.trailing)
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 6)
        .cornerRadius(5, corners: [.bottomLeft, .bottomRight])
        
    }
}
//
//struct CustomNavigationTitle_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomNavigationTitle()
//    }
//}
