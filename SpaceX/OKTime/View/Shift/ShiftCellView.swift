//
//  ShiftCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/13/22.
//

import SwiftUI

struct ShiftCellView: View {
    @State var time = "30"
    var shift: NewShift
    var colors: ConstantColors
    var body: some View {
        VStack {
            HStack {
                //Title Stack
                
                EmptyView()
                Spacer()
                
                
                VStack(alignment:.trailing) {
                    HStack {
                        Text("\(shift.duration)")
                            .font(.system(size: 14))
                        Text("هر نوبت :")
                            .foregroundColor(colors.darkGrayColor)
                            .font(.system(size: 12))
                        Image("timer-2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    .offset(x: 20)
                    HStack {
                        //ForEach should be assigned
                        ForEach(shift.days, id: \.self) { day in
                            HStack {
                                Text(day)
                                .foregroundColor(colors.darkGrayColor)
                                .font(.system(size: 13))
                            }
                            
                        }

                    }
                    
                }

                VStack(alignment:.trailing) {
                    

                    
                    Text(shift.title)
                    HStack {
                        Text(shift.startHour)
                            .font(.system(size: 10))
                        Text("الی")
                            .font(.system(size: 10))
                        Text(shift.endHour)
                            .font(.system(size: 10))
                        Image("clock-standby")
                    }
                }
                .padding()
                //Time stack
            }
        }
    }
}
//
//struct ShiftCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShiftCellView(colors: ConstantColors())
//    }
//}
