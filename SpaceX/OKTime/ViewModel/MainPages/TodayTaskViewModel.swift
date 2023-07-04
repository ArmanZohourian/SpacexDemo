//
//  TodayTaskViewModel.swift
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
class TodayTaskViewModel: ObservableObject {
    
    @Published var todayTasks = [Book]() {
        didSet {
            print(todayTasks)
        }
    }
    @Published var selectedDate : Date = Date()
    
    private var requestManager = RequestManager.shared
    
    func getBookings(with date: Date) async {

        do {
            
            let generatedDate = generatedDate(date: date)
            DispatchQueue.main.async { [weak self] in
                self?.selectedDate = date
            }
            
            let resultContainer : BookResponse = try await requestManager.perform(Booking.getBooking(selectedDate: generatedDate))
            
            
            DispatchQueue.main.async { [weak self] in
                
                self?.todayTasks = [Book]()
                for task in resultContainer.data.books {
                    self?.todayTasks.append(task)
                }
                
            }

            
            print(resultContainer)
            
        }
        catch {
            print("Error")
        }

    }
    
    
    
    private func generatedDate(date: Date) -> String {
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "En")
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
        
    }
    
}
