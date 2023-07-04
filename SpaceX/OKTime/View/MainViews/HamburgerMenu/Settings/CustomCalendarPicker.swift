//
//  CustomCalendarPicker.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/26/22.
//

import SwiftUI

struct CustomCalendarPicker: View {
    
    @Binding var isPresented: Bool
    @State var selectedValue: String = ""
    
    var selectionTitle: String = "App language"
    var options = ["Gregorian", "Jalali"]
    
    var body: some View {
         
    
        VStack {
            Picker(selection: $selectedValue) {

                ForEach(options, id: \.self) { option in
                    Text(option)
                        .tag(option)
                }
                
            } label: {
                
            }
            .pickerStyle(.wheel)
            .overlay(alignment: .top) {
                HStack {
                    Image("close-circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation {
                                isPresented.toggle()
                            }
                        }
                    Spacer()
                    Text(selectionTitle)
                    Spacer()
                    Image("check-circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            changeCalendar(selectedValue)
                            withAnimation {
                                isPresented.toggle()
                            }
                        }
                }
                .padding()
            }
        }
        .transition(.move(edge: .bottom))
        .background(
            Color.white
        )
        .shadow(radius: 3)
    
    }
    
    
    private func changeCalendar(_ tag: String) {
        
        switch tag {
        case "Jalali":
            LocalizationService.shared.calendarType = .jalali
            
            
        case "Gregorian":
            LocalizationService.shared.calendarType = .georgian
            
        case "جلالی":
            LocalizationService.shared.calendarType = .jalali
            
        case "میلادی":
            LocalizationService.shared.calendarType = .georgian
            
        default:
            break
        }
        
    }
    
}
