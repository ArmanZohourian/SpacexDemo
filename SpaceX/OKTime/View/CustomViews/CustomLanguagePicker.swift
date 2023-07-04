//
//  CustomSelectMenu.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/25/22.
//

import SwiftUI

struct CustomLanguagePicker: View {
    
    
    
    @Binding var isPresented: Bool
    @State var selectedValue: String = ""
    
    var selectionTitle: String = "App language"
    var options = ["فارسی", "English"]
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
                            changeLanguage(selectedValue)
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
    
    
    private func changeLanguage(_ tag: String) {
        
        switch tag {
        case "فارسی":
            LocalizationService.shared.language = .persian
            return
        case "English":
            LocalizationService.shared.language = .english
        default:
            break
        }
        
    }
    
    
}
