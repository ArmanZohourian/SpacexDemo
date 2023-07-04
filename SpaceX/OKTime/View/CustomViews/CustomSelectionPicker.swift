//
//  LanguagePickerCustomView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/2/22.
//

import SwiftUI

struct CustomSelectionPicker: View {
    
    var colors : ConstantColors
    
    var options = ["فارسی" , "انگلیسی"]
    
    @Binding var selectedValue : String {
        didSet {
            print(selectedValue)
        }
    }
    

    
    var labelText = "Language"
    @Binding var errorMessage: String
    @Binding var hasError: Bool
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .trailing, spacing: 10) {
                Text(labelText)
                    .padding(.trailing, 10)
                    .foregroundColor(colors.blueColor)
                    .font(.custom("YekanBakhNoEn-Bold", size: 14))
                
                    ZStack {
                        HStack {
                            
                            Image("arrow-down")
                            Spacer()
                            Text(String(selectedValue))
                                .foregroundColor(colors.blueColor)
                                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                            
                        }
                        .padding()
                    }
                    .frame(width: UIScreen.screenWidth - 20, height: 50)
                    .border(colors.lightGrayColor, width: 0.5)
                
                
                Text(errorMessage)
                    .foregroundColor(colors.redColor)
                    .opacity(hasError ? 1.0 : 0.0)
                    .font(.custom("YekanBakhNoEn-Bold", size: 11))
                    .foregroundColor(Color.red)
                    .padding(.trailing, 0)
                    
            }
            

            
            
        }
            
    }
}

//
//struct LanguagePickerCustomView_Previews: PreviewProvider {
//    
//    static var colors: ConstantColors = ConstantColors()
//    static var previews: some View {
//        LanguagePickerCustomView(colors: colors)
//    }
//}
