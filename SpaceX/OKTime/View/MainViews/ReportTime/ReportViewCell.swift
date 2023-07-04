//
//  ReportViewCell.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/20/22.
//

import SwiftUI

struct ReportViewCell: View {
    
    var colors: ConstantColors
    var body: some View {
        
        HStack {
            
            Image("shield-tick-2")
            
            Spacer()
            HStack {

                VStack{
                    Text("تو")
                    Text("مان")
                }
                .foregroundColor(colors.blueColor)
                .font(.system(size: 12))
                
                Text("1,000,000")
                    .foregroundColor(colors.greenColor)
                    .font(.system(size: 12))
         
                HStack {
                    Text("1401/04/29")
                        .font(.system(size: 10))
                        .foregroundColor(colors.blueColor)
                    Text("تاریخ :")
                        .font(.system(size: 13))
                        .foregroundColor(colors.grayColor)
                }
                
            }
    
            Text("علی حسینی")
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.red)
                .cornerRadius(20)
            
        }
        .frame(width: UIScreen.screenWidth - 30, height: 60)
        .background(Color.white)
        
    }
}

struct ReportViewCell_Previews: PreviewProvider {
    
    static var colors : ConstantColors = ConstantColors()
    static var previews: some View {
        ReportViewCell(colors: colors)
    }
}
