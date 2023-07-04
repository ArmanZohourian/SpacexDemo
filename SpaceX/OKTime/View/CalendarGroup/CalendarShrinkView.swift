//
//  CalendarShrinkView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/10/22.
//

import SwiftUI

struct CalendarShrinkView: View {
    
    
    
    @AppStorage("calendar", store: .standard) var calendarType = "Jalali"

    var colors: ConstantColors
    
    @State var selectedDate = Date()
    
    @State var events = [EventDetails]()
    
    @EnvironmentObject var calendarViewModel : CalendarViewModel
       
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
    
    
    private var dayEn: String {
        GregorianHelper.DayEn.string(from: selectedDate)
    }
    
    private var monthEn: String {
        GregorianHelper.MonthEn.string(from: selectedDate)
    }
    
    
    private var yearEn: String {
        GregorianHelper.YearEn.string(from: selectedDate)
    }
    
    
    private var weekDays: [String] {
        generatedWeekDays(withDays: Date.getNextSevenWeekDays(forLastNDays: 7))
        
    }
    
    
    private var generatedDays: [Date] {
        getCurrentWeekDates()
    }
    
    private var currentWeek: [Date] {
        getCurrentWeekDates()
    }
    
    
    
    private var dateFormmater : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
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
                   .environment(\.layoutDirection, LocalizationService.shared.calendarType == .georgian ? .leftToRight : .rightToLeft)
                   .task {
                       await calendarViewModel.getCalendarStatus()
                   }
                   #if os(macOS)
                   .shadow(color: .accentColor.opacity(0.15), radius: 2)
                   #endif
           }
           
           
       }
       
       var content: some View {
           
           let dateBinding = Binding(
               get: { self.selectedDate },
               set: {
                   print("Old value was \(self.selectedDate) and new date is \($0)")
                   self.selectedDate = $0
                   Task {
                       await calendarViewModel.getCalendarStatus(withDate: selectedDate)
                   }
               }
           )

            return VStack(alignment: .center, spacing: 3) {
                

                // MARK: - Calendar Month View
                VStack(spacing: -10) {
                    
                    
                    HStack {
                        ForEach(generatedDays, id: \.self) { date in
                            
                            VStack(spacing: -10) {
                                
                                if checkReserveCounts(withLocalDate: date) != "0" {
                                    ZStack {
                                        Rectangle()
                                            .frame(width: 17, height: 17)
                                            
                                            .overlay(alignment: .center) {
                                                Text(checkReserveCounts(withLocalDate: date))
                                                    .font(.system(size: 9))
                                                    .foregroundColor(colors.blueColor)
                                            }
                                            .foregroundColor(colors.calendarCellGreenColor)
                                            .clipShape(Circle())
                                            .offset(x: -15)
                                    }
                                }
                            
                                if calendarType == "Jalali" {
                                    Text(generatedShortDayFa(withDay: dateFormmater.string(from: date)))
                                        .foregroundColor(generatedShortDayFa(withDay: dateFormmater.string(from: date)) == "ج" ? Color.red : Color.white)
                                        .frame(minWidth: 45)
                                        .font(.system(size: 15, weight: .heavy, design: .default))
                                } else {
                                    Text(generatedShortDayEn(withDay: dateFormmater.string(from: date)))
                                        .foregroundColor(generatedShortDayEn(withDay: dateFormmater.string(from: date)) == "Sun" ? Color.red : Color.white)
                                        .frame(minWidth: 45)
                                        .font(.system(size: 15, weight: .heavy, design: .default))
                                }

                                
                            }
            
                        }
                    }
                    
                    .frame(width: UIScreen.screenWidth)
                    .padding()
                    
                    HStack {
                        ForEach(generatedDays, id: \.self) { date in
                            
                            
                            VStack(spacing: 1) {
        
                                Text("30")
                                    .frame(minWidth: 45)
                                    .hidden()
                                    .overlay {
                                        Text(calendarType == "Jalali" ? JalaliHelper.DayFa.string(from: date) : GregorianHelper.DayEn.string(from: date))
                                            .containerShape(Circle())
                                            .foregroundColor(
                                            date.checkIsToday(date: Date()) ? colors.blueColor : Color(.white)
                                            )
                                        
                                        
                                    }
                                
                                    .background(content: {
                                        date.checkIsToday(date: selectedDate) ?
                                        colors.calendarCellGreenColor:
                                        Color(red: 14 / 255, green: 31 / 255 , blue: 80 / 255, opacity: 1)
                                    })

                                
                                    .clipShape(Circle())
                                    .animation(.easeIn, value: selectedDate)
                                    .onTapGesture {
                                        selectedDate = date
                                        print(date)
                                    }
                                
                                if date.checkIsToday(date: Date()) {
                                    Rectangle()
                                        .frame(width: 4, height: 4)
                                        .background(colors.calendarCellGreenColor)
                                        .foregroundColor(colors.calendarCellGreenColor)
                                        .cornerRadius(30)
                                }
                            }

                        }
                        
                    }
                    .frame(width: UIScreen.screenWidth)
                    .padding()
                }
            }
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
        print("HERE ARE THE GENERATED DAYS")
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
    
    private func getCurrentWeekDates() -> [Date] {
        return Date.getDateInBetween(startDate: Date().startOfCurrentWeek(), endDate: Date().endOfCurrentWeek())
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
    
    
}

struct CalendarShrinkView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarShrinkView(colors: ConstantColors())
    }
}
