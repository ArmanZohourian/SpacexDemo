//
//  CustomSelectionMenu.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/25/22.
//

import SwiftUI

struct CustomSelectionMenu: View {

    @Binding var isPresented: Bool
    @Binding var selectedValue: String
    
    @State var selection = "Male"
    
    var selectionTitle: String = "App language"
    var options = ["فارسی", "English"]
    var body: some View {
        
    
        VStack {
            
            Picker(selection: $selection) {

                ForEach(options, id: \.self) { option in
                    Text(option)
                        .tag(option)
                }
                
            } label: {
                
            }
            .pickerStyle(.wheel)
            .overlay(alignment: .top) {
                HStack {
                    Image("check-circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            selectValue(with: selection)
                            withAnimation {
                                isPresented.toggle()
                            }
                        }
                        .padding()
                    
                    Spacer()
                    Text(selectionTitle)
                    Spacer()
                    
                    Image("close-circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation {
                                isPresented.toggle()
                            }
                        }
                }
                .padding([.leading, .trailing])
            }
        }
        .transition(.move(edge: .bottom))
        .background(
            Color.white
        )
        .shadow(radius: 3)
    
    }
    
    private func selectValue(with selectedValue: String) {
        self.selectedValue = selectedValue
    }

}

