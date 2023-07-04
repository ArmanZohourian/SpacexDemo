//
//  TimeViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/24/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class TimeViewModel: ObservableObject {
    
    private var requestManager = RequestManager.shared
    
    
    @Published var bookReports = [Book]()
    
    @Published var incomeReport: IncomeReport?
    
    @Published var date = Date()
    
    @Published var startDate = Date() {
        didSet {
            print("Start Date has been changed")
            isStartDateSet = true
        }
    }
    
    @Published var isStartDateSet = false
    
    @Published var endDate = Date() {
        didSet {
            print("End date has been changed")
            isEndDateSet = true
        }
    }
    
    @Published var isEndDateSet = false
    
    @Published var statusReports = [CalendarReport]()
    
    @Published var globalStatus = false
    
    
    private var dateForammatter : DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "En")
        
        return dateFormatter
    }
    
    func getIncomeReports() async  {
        
        
        //Request Instance
        
        let todaysDate = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "EN")
        
        let todayDateStr = df.string(from: todaysDate)
        let generatedEndDate = df.date(from: Date.getNextWeekDay(forLastNDays: 7))
        let generatedEndDateStr = df.string(from: generatedEndDate!)
        

        do{
            
            let container: IncomeReportResponse = try await requestManager.perform(GetIncomeReport.getIncome(startDate: todayDateStr , endDate: generatedEndDateStr))
            
            if container.status {
                
                DispatchQueue.main.async { [weak self] in
                    self?.incomeReport = IncomeReport(income: container.data!.income, totalIncome: container.data!.totalIncome)
                }

            }
        }
        
        catch {
            
            print("Error")
            
        }
    }
    
    
    func getBookings(with date: String) async {
        
        do {
            DispatchQueue.main.async { [weak self] in
                self?.bookReports = [Book]()
            }
            let resultContainer : BookResponse = try await requestManager.perform(Booking.getBooking(selectedDate: date))
            
            for task in resultContainer.data.books {
                self.bookReports.append(task)
            }
            
            print(resultContainer)
            
        }
        catch {
            print("Error")
        }

    }
    
    func getBookingsWithDates(startDate: Date, endDate: Date) async {
        
        
    
        do {
            
            DispatchQueue.main.async { [weak self] in
                self?.bookReports = [Book]()
            }
            
            let resultContainer : BookResponse = try await requestManager.perform(GetBookingsFiltered.getReportWithDates(startDate: dateForammatter.string(from: startDate), endDate: dateForammatter.string(from: endDate)))
            
            for task in resultContainer.data.books {
                self.bookReports.append(task)
            }
            
            print(resultContainer)
            
        }
        catch {
            print("Error")
        }
        
    }
    
    func getCalendarStatus() async {
        
        //Make the request
        do {
            let resultContainer: CalendarResponse = try await requestManager.perform(getCalendar.getCalendarWith)
            print("THIS IS THE CONTAINER")
            
            if resultContainer.status {
                DispatchQueue.main.async { [weak self] in
                    for event in resultContainer.data {
                        self?.statusReports.append(CalendarReport(date: event.date, reserveCount: event.reserveCount, totalCost: event.totalCost ?? -1, isHoliday: event.isHoliday, cancelCount: event.cancelCount, doneCount: event.doneCount))
                    }
                    self?.globalStatus = true
                }
            }
            
            print(resultContainer)
        }
        catch {
            
            
            print("Error")
            
        }

        
    }
    
}
