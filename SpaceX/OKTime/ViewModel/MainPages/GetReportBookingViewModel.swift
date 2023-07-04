//
//  GetReportBookingViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class GetReportBookingViewModel: ObservableObject {
    
    
    private var requestManager = RequestManager.shared
    
    @Published var taskReports = [Book]() {
        didSet {
            print("Getting Books")
        }
    }
    
    
    func getReportBooking() async {
        
        do {
            await MainActor.run(body: {
                taskReports = [Book]()
            })
        
            let resultContainer : BookResponse = try await requestManager.perform(GetReportBooking.getReportBooking)
            
            await MainActor.run(body: {
                for task in resultContainer.data.books {
                    self.taskReports.append(task)
                }
            })
            
        }
        
        catch {
            
            
        }
        
    }
    
    
    
}
