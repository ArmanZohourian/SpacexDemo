//
//  CalendarViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/17/22.
//

import Foundation

/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class CalendarViewModel: ObservableObject {
    
    
    private var requestManager = RequestManager.shared
    
    @Published var events = [CalendarEvent]()
    
    @Published var reports = [CalendarReport]()

    @Published var globalStatus = false
    
    @Published var isRequesting = false
    
    private var dateFormatter : DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
        
    }
    
    //Request to server
    func getCalendarStatus() async {
        
        //Make the request
        do {
            
            let resultContainer: CalendarResponse = try await requestManager.perform(getCalendar.getCalendarWith)
            
            
            if resultContainer.status {
                DispatchQueue.main.async { [weak self] in
                    self?.events = [CalendarEvent]()
                    
                    for event in resultContainer.data {
                        self?.events.append(CalendarEvent(titleLocal: event.titleLocal, date: event.date))
                        self?.reports.append(CalendarReport(date: event.date, reserveCount: event.reserveCount, totalCost: event.totalCost ?? 0 , isHoliday: event.isHoliday, cancelCount: event.cancelCount, doneCount: event.doneCount))
                    }
                    self?.globalStatus = true
                }
            }
            
        }
        catch {
            
    
        }

        
    }
    
    
    func getCalendarStatus(withDate date: Date) async {
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        
        //Make the request
        do {
            let resultContainer: CalendarResponse = try await requestManager.perform(CalendarStatusWithDates.getStatusWithDates(startDate: dateFormatter.string(from: date.startOfMonth()), endDate: dateFormatter.string(from: date.endOfMonth())))
            print("THIS IS THE CONTAINER")
            
            if resultContainer.status {
                
                DispatchQueue.main.async { [weak self] in
                    self?.events = [CalendarEvent]()
                    self?.reports = [CalendarReport]()
                    self?.isRequesting = false
                    for event in resultContainer.data {
                        
                        self?.events.append(CalendarEvent(titleLocal: event.titleLocal, date: event.date))
                        self?.reports.append(CalendarReport(date: event.date, reserveCount: event.reserveCount, totalCost: event.totalCost ?? 0 , isHoliday: event.isHoliday, cancelCount: event.cancelCount, doneCount: event.doneCount))
                    }
                    self?.globalStatus = true
                }
            }
            
            
        }
        catch {
            
            DispatchQueue.main.async { [weak self] in
                self?.isRequesting = false
            }
            
            print("CalendarError")
            
        }
    }
    
    
    

    
    
    
}
