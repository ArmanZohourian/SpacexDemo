//
//  CustomCalendarTypeView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import Foundation
import SwiftUI
struct CustomCalendarTypeView: View {
    
    var colors : ConstantColors
    
    var options = ["شمسی" , "میلادی"]
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
                    .font(.system(size: 15, weight: .semibold, design: .default))
                
                Menu {
                    Picker(selection: $selectedValue, label: EmptyView()) {
                        ForEach(options, id: \.self) { language in
                            Text(language)
                                .tag(language)
                                .foregroundColor(colors.blueColor)
                        }
                    }
                } label: {
                    ZStack {
                        HStack {
                            
                            Image("arrow-down")
                            Spacer()
                            Text(String(selectedValue))
                                .foregroundColor(colors.blueColor)
                            
                        }
                        .padding()
                    }
                    
                    .frame(width: UIScreen.screenWidth - 20, height: 50)
                    .border(colors.lightGrayColor, width: 0.5)
                    
                }
            }
            
            
        }
            
    }
}
