//
//  CustomDatePicker.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI

struct CustomDatePicker: View {
    
    
    @Binding var isPresented: Bool
    
    @Binding var date: Date
    
    var language = LocalizationService.shared.language
    
    var body: some View {
        
        VStack {
        
            DatePicker("Working here", selection: $date, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .environment(\.locale, .init(identifier: language == .persian ? "Fa" : "En"))
                .environment(\.calendar, language == .persian ? .persianCalendar : .gregorianCalendar)
                .frame(width: UIScreen.screenWidth)
                .background(Color.white)
                .labelsHidden()
                .transition(.move(edge: .bottom))
                .shadow(radius: 0.3)

        }
        
    }
}

