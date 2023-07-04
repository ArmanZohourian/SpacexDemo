//
//  ShiftCellHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/1/22.
//

import SwiftUI

struct ShiftCellHamburgerView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    

    var shift: ShiftDetail
    
    var colors: ConstantColors
    
    var generatedDayCount = 0
    
    @State var shiftDays = ""
    
    @State var shiftStartTime: Date = Date()
    
    @State var shiftEndTime: Date = Date()
    
    @State var shiftDuration: Date = Date()
    
    
    
    
    
    
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
    
    
    var shiftDurationFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    
    var body: some View {
        
        VStack {
            HStack {
                //Title Stack
                
                EmptyView()
                Spacer()
                
                VStack(alignment: .center) {
                    
                    
                    
                    HStack {
                        Text("\(shiftDuration ,formatter: shiftDurationFormat)")
                            .font(.custom("YekanBakhNoEn-SemiBold", size: 14))
                        
                        Text("shift_each_shift".localized(language))
                            .foregroundColor(colors.darkGrayColor)
                            .font(.custom("YekanBakhNoEn-Regular", size: 14))
                        
                        Image("timer-2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    
            
                    
                    Text(shiftDays)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                        .foregroundColor(colors.darkGrayColor)
                        .frame(maxWidth: 100)
                        .frame(maxHeight: 35)
                        .frame(alignment: .center)
                    
                    
                }
                .padding(.top)

                VStack(alignment:.trailing) {
                    
                    Text(shift.name)
                        .font(.custom("YekanBakhNoEn-SemiBold", size: 17))
                    
                    HStack {
                        
                        Text("\(shiftEndTime ,formatter: timeFormatter)")
                            .font(.custom("YekanBakhNoEn-Regular", size: 14))
                            .foregroundColor(colors.grayColor)
                        
                        Text("shift_to_time".localized(language))
                            .font(.custom("YekanBakhNoEn-Regular", size: 14))
                            .foregroundColor(colors.grayColor)
                        
                            
                        Text("\(shiftStartTime ,formatter: timeFormatter)")
                            .font(.custom("YekanBakhNoEn-Regular", size: 14))
                            .foregroundColor(colors.grayColor)
                            
                        Image("clock-standby")
                            .resizable()
                            .frame(width: 17, height: 17)
                        
                    }
                }
                .padding()
                //Time stack
            }
        }
        
        .background(colors.cellColor)
        .onAppear {
            shiftStartTime = serverTimeFormat.date(from: shift.start)!
            shiftEndTime = serverTimeFormat.date(from: shift.end)!
            shiftDuration = serverTimeFormat.date(from: shift.bookDuration)!
            setDays()
            
        }
        
    }
    
    
    
    private func generateDay(with day: String) -> String {
        
        
        
        switch day {
            case "SATURDAY":
            
            return "saturday_short".localized(language)
            case "SUNDAY":
            
            return "sunday_short".localized(language)
            case "MONDAY":
            
            return "monday_short".localized(language)
            case "TUESDAY":
            
            return "tuesday_short".localized(language)
            case "WEDNESDAY":
            
            return "wednesday_short".localized(language)
            case "THURSDAY":
            
            return "thursday_short".localized(language)
            case "FRIDAY":
        
            return "firday_short".localized(language)
        default:
            return ""
        }
        
    }
    
    private func setDays() {
        for day in shift.weekDay {
            shiftDays += " \(generateDay(with: day))"
        }
    }
    
}


//
//struct ShiftCellHamburgerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShiftCellHamburgerView()
//    }
//}
