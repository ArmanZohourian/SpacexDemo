//
//  TimeTableCustomView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/18/22.
//

import SwiftUI

struct TimeTableCustomView: View {
    var colors: ConstantColors
    var shiftName: String = "شیفت صبح"
    var shiftTime: String = "08:30 AM"
    var shiftDay: String = "شنبه"
    @Binding var isSelected: Bool
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(width: 60, height: 60)
                .cornerRadius(5)
                .overlay(
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text(shiftDay)
                            .font(.system(size: 12))
                            
                        Text(shiftTime)
                            .font(.system(size: 12))
                            .foregroundColor(colors.blueColor)
                        Text(shiftName)
                            .font(.system(size: 12))
                            .foregroundColor(colors.yellowColor)
                    }

                )
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(colors.blueColor, lineWidth: 1)
                )
            
                .onTapGesture {
//                    selectDay(with: day)
//                    print(isSelectedDay(with: day))
                }

            

                .foregroundColor(Color.black)
            
            
        }
        
    }
}


//
//
//struct TimeTableCustomView_Previews: PreviewProvider {
//    static var constantColors = ConstantColors()
//    static var previews: some View {
//        TimeTableCustomView(colors: constantColors)
//    }
//}
