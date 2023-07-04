//
//  ScheduleCalendarView.swift
//  
//
//  Created by Arman Zohourian on 11/24/22.
//

import Foundation
import SwiftUI

struct ScheduleCalendarView : View {
    
        @AppStorage("calendar", store: .standard) var calendarType = "Jalali"
    
    var language = LocalizationService.shared.language

       var colors: ConstantColors
    
       @Binding var selectedDate : Date
    
       @State var events = [EventDetails]()
    
       @State var isExpanded = false
       
       @StateObject var calendarViewModel = CalendarViewModel()
    
       @EnvironmentObject var timeTableViewModel: TimeTableViewModel
    
       @Environment(\.calendar) var calendar
    
       @Environment(\.scenePhase) var scenePhase
       #if os(iOS)
       @Environment(\.horizontalSizeClass) private var horizontalSizeClass
       #endif
       
       private var dayWeekFa: String {
           JalaliHelper.DayWeekFa.string(from: selectedDate)
       }
       
       private var yearFa: String {
           JalaliHelper.YearFa.string(from: selectedDate)
       }
       
       private var monthFa: String {
           JalaliHelper.MonthFa.string(from: selectedDate)
       }
       
       private var dayFa: String {
           JalaliHelper.DayFa.string(from: selectedDate)
       }
    
    private var weekDays: [String] {
        generatedWeekDays(withDays: Date.getNextSevenWeekDays(forLastNDays: 7))
        
    }
    
    private var dateFormmater : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }
    
    
    private var generatedDays: [Date] {
        generatednextSevenDays()
    }
       
       var body: some View {
           ZStack {
               #if os(iOS)
//               colors.blueColor
//                   .edgesIgnoringSafeArea(.all)
               #elseif os(macOS)
   //            VisualEffectBlur(material: .popover, blendingMode: .behindWindow)
                   .edgesIgnoringSafeArea(.all)
               #endif

               
                    content
                        .task {
                            await calendarViewModel.getCalendarStatus()
                        }
               
               
               

        

            
                   #if os(macOS)
                   .shadow(color: .accentColor.opacity(0.15), radius: 2)
                   #endif
           }
           
           .environment(\.layoutDirection, .rightToLeft)
       }
       
       var content: some View {

               VStack(alignment: .center, spacing: 3) {

                   // MARK: - Calendar Month View
                   VStack(spacing: -5) {
                       HStack {
                           ForEach(generatedDays, id: \.self) { date in
                               
                               VStack(spacing: -10) {
                                   
                                   //Check reserve count stack
                                   if checkReserveCounts(withLocalDate: date) != "0" {
                                    
                                       ZStack {
                                           Rectangle()
                                               .frame(width: 17, height: 17)
                                               
                                               .overlay(alignment: .center) {
                                                   Text(checkReserveCounts(withLocalDate: date))
                                                       .font(.system(size: 9))
                                                       .foregroundColor(Color.white)
                                               }
                                               .foregroundColor(colors.calendarCellBlueColor)
                                               .clipShape(Circle())
                                               .offset(x: -15)
                                       }
                                   }
                                
                                   
                                   //Check the calendar type
                                   //If it's a valid day or not
                                   if calendarType == "Jalali" {
                                       Text(generatedShortDayFa(withDay: dateFormmater.string(from: date)))
                                           .frame(minWidth: 45)
                                           .font(.system(size: 15, weight: .heavy, design: .default))
                                           .foregroundColor(!isValidDay(with: date) ? Color.gray : Color.white)
                                           .foregroundColor(generatedShortDayFa(withDay: dateFormmater.string(from: date)) == "ج" ? Color.red : Color.white)
                                           
                                       
                                       
                                   } else {
                                       
                                       
                                       Text(generatedShortDayEn(withDay: dateFormmater.string(from: date)))
//                                           .foregroundColor(generatedShortDayEn(withDay: dateFormmater.string(from: date)) == "Sun" ? Color.red : Color.white)
                                           .frame(minWidth: 45)
                                           .font(.system(size: 15, weight: .heavy, design: .default))
                                           .foregroundColor(!isValidDay(with: date) ? Color.gray : Color.white)
                                           
                                       
                                   }
                                  
                               }
                
                           }
                       }
                       
                       .frame(width: UIScreen.screenWidth)
                       .padding()
                       
                       HStack {
                           ForEach(generatedDays, id: \.self) { date in
                               Text("30")
                                   .frame(minWidth: 45)
                                   .hidden()
                                   .overlay {
                                       Text(calendarType == "Jalali" ? JalaliHelper.DayFa.string(from: date) : GregorianHelper.DayEn.string(from: date))
                                           .containerShape(Circle())
                                           .foregroundColor(!isValidDay(with: date) ? Color.gray : Color.white)
                                           
                                       
                                       
                                   }
                                   
                               
                                   .background(content: {
                                       date.checkIsToday(date: selectedDate) ?
                                       colors.calendarCellBlueColor:
                                       Color(red: 14 / 255, green: 31 / 255 , blue: 80 / 255, opacity: 1)
                                   })
                               
                                   .clipShape(Circle())
                                   .animation(.easeIn, value: selectedDate)
                                   .onTapGesture {
                                       selectedDate = date
                                       print(date)
                                   }
                                   .disabled(!isValidDay(with: date) ? true : false)
                           }
                           
                       }
                       .frame(width: UIScreen.screenWidth)
                       .padding()
                   }
               }
               .environment(\.layoutDirection, language == .persian ? .rightToLeft : .leftToRight)
               .foregroundColor(Color.white)
               .padding()
           #if os(iOS)
           .safeAreaInset(edge: .top) {
               HStack {
                   Spacer()
               }
               .background(Color("BackgroundColor"))
               .blur(radius: 5)
           }
           #endif
           .onChange(of: scenePhase) { _ in
               selectedDate = Date()
               getEvents()
           }
       }
       
    func getEvents() {
        EventService.shared.read { (result) in
            switch result {
            case .success:
                do {
                    events.removeAll()
                    let eventsData = try result.get()
                    for item in eventsData {
                        if item.day == Int(JalaliHelper.DayEn.string(from: selectedDate)) && item.month == Int(JalaliHelper.MonthEn.string(from: selectedDate)) {
                            events.append(item)
                        }
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
       
    func moveDate(to date: Date) {
        #if os(iOS)
        let hapticGenerator = UIImpactFeedbackGenerator(style: .soft)
        hapticGenerator.impactOccurred()
        #endif
        withAnimation(.interactiveSpring()) {
            selectedDate = date
            getEvents()
        }
    }
    
    private func generatedWeekDays(withDays days: [String]) -> [String] {
        
        
        var generatedDays : [String] = [String]()
        
        for day in days {
            
            generatedDays.append(generatedShortDayFa(withDay: day))
            
            
        }
        print(generatedDays)
        return generatedDays
    }
    
    private func generatedShortDayFa(withDay day: String) -> String {
        
        
            switch day {
                
                
            case "شنبه":
                return "ش"
            
            case "یکشنبه":
                return "ی"
            
            case "دوشنبه":
                return "د"
                
            case "سه‌شنبه":
                return "س"
                
            case "چهارشنبه":
                return "چ"
                
            case "پنجشنبه":
                return "پ"
                
            case "جمعه":
                return "ج"
                
            
            case "Saturday":
                return "ش"
                
            case "Sunday":
                return "ی"
                
            case "Monday":
                return "د"
                
            case "Tuesday":
                return "س"
            
            case "Wednesday":
                return "چ"
            
            case "Thursday":
                return "پ"
                
            case "Friday":
                return "ج"
            
            default:
                break
            }
        
        return "day"
    }
    
    private func generatedShortDayEn(withDay day: String) -> String {
        
        
            switch day {
                
                
            case "شنبه":
                return "Sat"
            
            case "یکشنبه":
                return "Sun"
            
            case "دوشنبه":
                return "Mon"
                
            case "سه‌شنبه":
                return "Tue"
                
            case "چهارشنبه":
                return "Wed"
                
            case "پنجشنبه":
                return "Thu"
                
            case "جمعه":
                return "Fri"
                
                
            case "Saturday":
                return "Sat"
                
            case "Sunday":
                return "Sun"
                
            case "Monday":
                return "Mon"
                
            case "Tuesday":
                return "Tue"
            
            case "Wednesday":
                return "Wed"
            
            case "Thursday":
                return "Thu"
                
            case "Friday":
                return "Fri"
                
            default:
                break
            }
        
        return "day"
    }
    
    private func generatednextSevenDays() -> [Date] {
        return Date.getNextSevenDaysExplicitDate(forLastNDays: 7)
    }
    
    private func checkReserveCounts(withLocalDate localDate: Date) -> String {

        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "En")
            return formatter
        }()

        
        var reserveCount = 0
    
        for day in calendarViewModel.reports {

            if day.date == dateFormatter.string(from: localDate) {
                reserveCount = day.reserveCount
                break
            } else {
                reserveCount = 0
            }
        }
        
        return String(reserveCount)
    }
    
    private func isValidDay(with date: Date) -> Bool {
        
        //If shift days are matched return false , otherwise true
        let timetables = timeTableViewModel.timeTable
        let generatedDay = dateFormmater.string(from: date).lowercased()
        
        for timetable in timetables {
            for day in timetable.weekDay {
                if generatedDay == day.lowercased() {
                    //valid day : color
                    return true
                }
            }
        }
        
        return false
    }
    
    
    
}
