//
//  EventsView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import SwiftUI

struct EventsView: View {
    
    var colors: ConstantColors
    @StateObject var todayTaskViewModel = TodayTaskViewModel()
    @EnvironmentObject var calendarViewModel : CalendarViewModel
    
    @Binding var selectedDate : Date
    
    @State var isEventsPresented = false
    
    private var monthFa: String {
        JalaliHelper.MonthFa.string(from: selectedDate)
    }
    
    private var yearFa: String {
        JalaliHelper.YearFa.string(from: selectedDate)
    }
    
    private var dayFa: String {
        JalaliHelper.DayFa.string(from: selectedDate)
    }
    

    var body: some View {
        
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
        
        return GeometryReader { geometry in
            VStack(alignment: .leading) {
                VStack(alignment: .trailing) {
                    HStack {
                        
                        
                        
                        Text("\(yearFa)")
                        Text(" \(monthFa) ماه")
                        Text("مناسب های")
                        
                    }
                    .font(.custom("YekanBakhNoEn-Regular", size: 20))
                    .padding(.trailing)
                    
                    VStack(alignment: .trailing) {
                        ScrollView {
                            VStack(alignment: .trailing) {
                                ForEach(calendarViewModel.events) { event in
                                    
                                        HStack {
                                            
                                            Text(event.titleLocal)
                                                .environment(\.layoutDirection,  .rightToLeft)
                                                .foregroundColor(colors.grayColor)
                                                .font(.custom("YekanBakhNoEn-Light", size: 12))
                                                .frame(alignment: .topTrailing)
                                                
                                                
                                            
                                            Text(getMonth(date: event.date))
                                                .foregroundColor(colors.blueColor)
                                                .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                                
                                                
                                        
                                            
                                            
                                            Text(getDay(date: event.date))
                                                .foregroundColor(colors.blueColor)
                                                .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                                
                                                
                                                
                                        }
                                        .padding()
                                        
                                }
                            }
                        }
                    }
                    .frame(alignment: .trailing)
                    
                        
                    
        
                    
                }
                .frame(alignment: .trailing)
                

                
            }
            .frame(width: geometry.size.width   , height: geometry.size.height, alignment: .trailing)
            .background(Color.white)
        }
        
        
    }
    
    
    private func getDay(date: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let newDate = df.date(from: date)
        
        return JalaliHelper.DayFa.string(from: newDate!)
        
    }
    
    private func getMonth(date: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let newDate = df.date(from: date)
        
        return JalaliHelper.MonthFa.string(from: newDate!)
        
        
    }
    
}
//
//struct EventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsView()
//    }
//}
