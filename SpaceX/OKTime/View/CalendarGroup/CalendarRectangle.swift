//
//  ContentView.swift
//  CalendarProject
//
//  Created by Arman Zohourian on 11/7/22.
//

import SwiftUI
import CoreData
//
//  ContentView.swift
//  Shared
//
//  Created by armin on 1/28/21.
//

import SwiftUI

struct CalendarRectangle: View {
    
    
    @AppStorage("calendar", store: .standard) var calendarType = "Jalali"
    
    var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    
    @Binding var isEventsPresented: Bool
    
    @EnvironmentObject var todayTaskViewModel: TodayTaskViewModel
    
    @Binding var selectedDate : Date
    
    @Binding var isCalendarExpanded: Bool
    
    var selectedDateStr: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: selectedDate)
    }
    
    @State var events = [EventDetails]()
    
    @EnvironmentObject var calendarViewModel : CalendarViewModel
    
    @Environment(\.calendar) var calendar
    @Environment(\.scenePhase) var scenePhase
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    
    //MARK: FA
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
    
    
    //MARK: EN
    private var dayEn: String {
        GregorianHelper.DayEn.string(from: selectedDate)
    }
    
    private var monthEn: String {
        GregorianHelper.MonthEn.string(from: selectedDate)
    }
    
    
    private var yearEn: String {
        GregorianHelper.YearEn.string(from: selectedDate)
    }
    
    
    
    private var monthsOfYear: [Date] {
        return Date().allMonthsOfYear()
    }
    
    
    var body: some View {


        return ZStack {


            content
                .task {
                    await calendarViewModel.getCalendarStatus(withDate: selectedDate)
                }
                .overlay(alignment: .bottom) {
                    Capsule()
                        .frame(width: 70, height: 5)
                        .foregroundColor(Color.gray.opacity(0.7))
                        .padding(.bottom, 3)
                        .gesture(DragGesture(minimumDistance: 1, coordinateSpace: .local).onChanged({ value in
                            isCalendarExpanded = false
                        }))
                }

        }
        .environment(\.layoutDirection, LocalizationService.shared.calendarType == .georgian ? .leftToRight : .rightToLeft)
        .environment(\.calendar, LocalizationService.shared.calendarType == .georgian ? .gregorianCalendar : .persianCalendar)
    }
    
    var content: some View {

        
        let dateBinding = Binding(
            get: { self.selectedDate },
            set: {
                print("Old value was \(self.selectedDate) and new date is \($0)")
                self.selectedDate = $0
//                Task {
//                    await calendarViewModel.getCalendarStatus(withDate: selectedDate)
//                }
            }
        )
        
        
        
           return VStack(alignment: .center, spacing: 1) {
                

                    // MARK: - Today contents
                    HStack(alignment: .center, spacing: 3) {
                        
                        
                        //Calendar Month Selection
                        Menu {
                            Picker("Select month", selection: dateBinding) {
                                ForEach(monthsOfYear, id: \.self) { date in
                                    
                                    Text(calendarType == "Jalali" ? JalaliHelper.MonthFa.string(from: date) :GregorianHelper.MonthEn.string(from: date))
                                        .font(.system(size: 13))
                                        .tag(date)
                                    
                                }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                
                                
                                Text(calendarType == "Jalali" ? "\(yearFa) \(monthFa)" : "\(yearEn) \(monthEn)")
                                    .allowsTightening(true)
                                
                                Image("arrow-down-green")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }

                        
                        .frame(height: 40)
                        .frame(width: 125)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 0.8)
                        )
                        


                        Spacer()
                        HStack(spacing: 5) {
                            
                            Image("calendar-main")
                            Text(isEventsPresented ? "schedule".localized(language) : "month_events".localized(language))
                        }
                        .onTapGesture {
                            isEventsPresented.toggle()
                        }
                        .foregroundColor(Color.white)
                        .foregroundColor(.red)
                    }
                    .foregroundColor(Color.white)
                    .padding([.leading, .trailing, .bottom] , 5)
                    .padding(.top, -20)
                    .environment(\.layoutDirection, .rightToLeft)
                // MARK: - Calendar Month View
                VStack(spacing: 0) {
                    HStack {
                        
                        
                        if calendarType == "Jalali" {
                            ForEach(["ش","ی","د","س","چ","پ","ج"], id: \.self) { day in
                                Text(day)
                                    .foregroundColor(day == "ج" ? Color.red : Color.white)
                                    .frame(minWidth: 45)
                            }
                        } else {
                            ForEach(["Sun","Mon","Tue","Wed","Thu","Fri","Sat"], id: \.self) { day in
                                Text(day)
                                    .foregroundColor(day == "Sun" ? Color.red : Color.white)
                                    .frame(minWidth: 45)
                            }
                        }

                        
                        
                    }
                    
                    MonthView(month: selectedDate, showHeader: false) { date in
                        
                        Text("30")
                            
                            .hidden()
                            .padding(8)
                            .frame(width: 50, height: 50, alignment: .top)
                            .overlay(
                        
                                ZStack {
                                    Circle()
                                        .foregroundColor(date.checkIsToday(date: Date()) ? colors.greenColor.opacity(0.5) : Color.clear)
                                        .frame(width: 10, height: 10, alignment: .center)
                                    
                                    Circle()
                                        .foregroundColor(date.checkIsToday(date: Date()) ? colors.greenColor : Color.clear)
                                        .frame(width: 4, height: 4, alignment: .center)
                                    
                                    
                                }
                                    .offset(x: -15 , y: -20)
                                
                            )
                            .padding(.vertical, 4)
                        //MARK: Calendar Content
                            .overlay(
                                ZStack {
                                    if checkIncome(withLocalDate: date) > "0" {
                                        Color.green.opacity(date.checkIsToday(date: selectedDate) ? 0.0 : 0.4)
                                    }
                                    isHoliday(withLocalDate: date) ? colors.redColor.opacity(0.5) : Color.clear
                                    VStack(spacing: 10) {
                                        Text(calendarType == "Jalali" ? JalaliHelper.DayFa.string(from: date) : GregorianHelper.DayEn.string(from: date))
                                            .foregroundColor(
                                                date.checkIsToday(date: Date()) ?
                                                Color.white:
                                                    Color(.white)
                                            )
                                        
                                        VStack(alignment: .leading) {
                                            
                                            if checkReserveCounts(withLocalDate: date) != "0" {
                                                Text(checkReserveCounts(withLocalDate: date) + "reserves".localized(language))
                                                    .font(.custom("YekanBakhNoEn-Regular", size: 9))
                    
                                            }
                                            
                                            if checkIncome(withLocalDate: date) != "0" {
                                                Text("\(checkIncome(withLocalDate: date))")
                                                .font(.system(size: 10))
                                            }
                                        }
                                    }
                                }
                                
                            )

                            .background(
                                date.checkIsToday(date: selectedDate) ?
                                colors.selectedDateColor :
                                    Color(red: 37 / 255, green: 51 / 255 , blue: 92 / 255, opacity: 1)
                            )
                        
                            .animation(.easeIn, value: selectedDate)
                            .onTapGesture {
                                moveDate(to: date)
                                selectedDate = selectedDate
                            }
                    }
                    .padding()
                }
            }
            .frame(width: UIScreen.screenWidth - 10)
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
    
    private func checkIncome(withLocalDate localDate: Date) -> String {
        
        let dateFormatter : DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.locale = Locale(identifier: "En")
           return formatter
       }()

       
       var income = 0
   
       for day in calendarViewModel.reports {

           if day.date == dateFormatter.string(from: localDate) {
               income = day.totalCost
               break
           } else {
               income = 0
           }
       }

       return String(income)
   }
    
    private func isHoliday(withLocalDate localDate: Date) -> Bool {
        
        let dateFormatter : DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.locale = Locale(identifier: "En")
           return formatter
       }()

       
       var status = false
   
       for day in calendarViewModel.reports {
           
           if day.date == dateFormatter.string(from: localDate) {
               status = day.isHoliday
               break
           } else {
               status = day.isHoliday
           }
       }
       
       return status
        
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
}
