//
//  CustomPickerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/19/22.
//

import SwiftUI

struct CustomOptionPickerView: View {
    
    @Binding var selectedItem: String {
        didSet {
            print(selectedItem)
        }
    }
    
    
    var options = [""]
    
    var body: some View {
        
        VStack {
            

            
            Picker("", selection: $selectedItem) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            
            .overlay(alignment: .topTrailing, content: {
                Button {
                    print(selectedItem)
                } label: {
                    Text("Show")
                }

            })
            
            .overlay(alignment: .topLeading, content: {
                Image("close-circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
            })
            .pickerStyle(.wheel)
            .background(Color.red)
            
        }
        
        
    }
}
