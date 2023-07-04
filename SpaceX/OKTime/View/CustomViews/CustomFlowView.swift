//
//  CustomFlowView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/6/22.
//

import SwiftUI

struct CustomFlowView: View {
    
    var colors: ConstantColors
    
    var flowDescription = ""
    
    var flowImage = ""
    
    var flowBgImage = ""
    
    var flowName: String?
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
        
            VStack(alignment: .trailing, spacing: 5) {
                
                Spacer()
                
                if let existingFlowName = flowName {
                    Text(existingFlowName)
                        .font(.custom("YekanBakhNoEn-Bold", size: 26))
                        .padding()
                }
                
                Text(flowDescription)
                    .aspectRatio(contentMode: .fit)
                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                    .padding()
                
                Image(flowImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth - 30, height: UIScreen.screenHeight / 22)
                
                
            }
            .padding(.bottom, 10)

        }
        
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 4)
        .foregroundColor(colors.whiteColor)
        .background(
            flowBgImage == "" ? AnyView(colors.blueColor) : AnyView(
                Image(flowBgImage)
                    .overlay(alignment: .center) {
                        Rectangle()
                            .foregroundColor(colors.imageShadeColor)
                            .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                    }
            )
        )
        .cornerRadius(8, corners: [.bottomRight, .bottomLeft])

    }
}
