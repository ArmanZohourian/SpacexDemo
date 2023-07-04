//
//  LogoutCell.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import SwiftUI

struct LogoutCell: View {
    
    
    var colors: ConstantColors
    
    var logo: String
    var name: String
    
    
    var body: some View {
        VStack {
                

            HStack(spacing: 10) {
                
                
                Text(name)
                    .foregroundColor(colors.redColor)
                    .font(.custom("YekanBakhNoEn-SemiBold", size: 16))
                
                Image(logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                

            }
            .frame(alignment: .leading)
            
            .padding()

                    
     
        }
        .frame(width: UIScreen.screenWidth - 10 , height: 50, alignment: .trailing)
        .background(colors.cellColor)
    }
}

