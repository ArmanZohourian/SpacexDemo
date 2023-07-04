//
//  HaburgerMenuCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI

struct HaburgerMenuCellView: View {
    

    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var cellText  = "مشخصات پروفایل"
    var cellIcon  = "profile"
    var colors: ConstantColors

    
    
    var body: some View {
        
        
        VStack {
            //MARK: Should be assinged as an navigation Link ( remove button later)

                HStack {
                    Image("arrow-left")
                        .flipsForRightToLeftLayoutDirection(language.rawValue == "en" ? true : false)
                    Spacer()
                    Text(cellText)
                        .foregroundColor(Color.white)
                        .font(.custom("YekanBakhNoEn-Bold", size: 16))
                    Image(cellIcon)
                    
                }
                .padding()

        }
        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
        .background(colors.menuCellColor)
        .cornerRadius(5)

        
    }
}


struct HaburgerMenuCellView_Previews: PreviewProvider {
    static var previews: some View {
        HaburgerMenuCellView(colors: ConstantColors())
    }
}
