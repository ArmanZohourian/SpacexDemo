//
//  CustomShiftView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/19/22.
//

import SwiftUI

struct CustomShiftView: View {
    
    var colors: ConstantColors
    @State var name = ""
    @State var time = ""
    @State var day = ""
    
    @State var generatedTime = Date()
    
    var serverTimeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        return formatter
    }
    
    
    
    var body: some View {
        
        
        VStack {
            Rectangle()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.white)
                .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(colors.blueColor, lineWidth: 1)
                )
            
                .overlay(alignment: .center) {
                    VStack {
                        Text(day)
                            .font(.system(size: 10))

                        Text("\(generatedTime ,formatter: timeFormatter)")
                            .font(.system(size: 11))
                            .foregroundColor(colors.blueColor)
                        
                        Text(name)
                            .font(.system(size: 9))
                            .foregroundColor(colors.yellowColor)

                    }
            }
        }
        .onAppear {
            generatedTime = serverTimeFormat.date(from: time)!
        }
            
    }
}
