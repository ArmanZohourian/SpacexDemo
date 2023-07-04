//
//  CustomCalendarPicker.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/15/22.
//

import SwiftUI

struct CustomCalendarPickerView: View {
    
    
    @AppStorage("language")
    
    var calendar = LocalizationService.shared.calendarType
    
    var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    
    var CalendarPicker: some View {
        
            
        VStack(alignment: .trailing, spacing: 10) {
            
            Text("calendar".localized(language))
                .foregroundColor(colors.blueColor)
                .padding(.trailing, 5)
                .foregroundColor(colors.blueColor)
                .font(.custom("YekanBakhNoEn-Bold", size: 14))
            
            Text(calendar == .georgian ? "gregorian".localized(language) : "jalali".localized(language))
                .foregroundColor(colors.blueColor)
                .font(.custom("YekanBakhNoEn-Regular", size: 14))
                .padding(.trailing)
                .frame(width: UIScreen.screenWidth - 20, height: 50, alignment: .trailing)
                .overlay(alignment: .leading, content: {
                    Image("arrow-down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 15)
                        .padding(.leading)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(colors.lightGrayColor, lineWidth: 0.5)
                )
        }
            
            
        
        
    }
    
    var body: some View {
        CalendarPicker
    }
    
}

