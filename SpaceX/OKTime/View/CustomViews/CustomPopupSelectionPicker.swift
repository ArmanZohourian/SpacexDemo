//
//  CustomPopupSelectionPicker.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/9/23.
//

import SwiftUI

struct CustomPopupSelectionPicker: View {
    
    var colors : ConstantColors
    
    var options = ["فارسی" , "انگلیسی"]
    
    @Binding var selectedValue : String {
        didSet {
            print(selectedValue)
        }
    }
    
    var labelText = "Language"
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .trailing, spacing: 10) {
                Text(labelText)
                    .padding(.trailing, 5)
                    .foregroundColor(colors.blueColor)
                    .font(.custom("YekanBakhNoEn-Bold", size: 14))
                    
                
                    ZStack {
                        HStack {
                            
                            Image("arrow-down")
                            Spacer()
                            Text(String(selectedValue))
                                .foregroundColor(colors.blueColor)
                            
                        }
                        .padding()
                    }
                    
                    .frame(width: UIScreen.screenWidth - 40, height: 40)
                    .border(colors.lightGrayColor, width: 0.5)
                    
            }
            
            
        }
            
    }
}
