//
//  GetReportViewModel.swift
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
class GetReportsViewModel: ObservableObject {
    
    
    private var requestManager = RequestManager.shared
    @Published var report = Reports(totalDone: 0, totalCancel: 0, averageTime: 0)
    
    
    func getReports() async {
        
        
        do {
         
            let container: ReportsResponse = try await requestManager.perform(GetReports.getReport)
        
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    let generatedReport = Reports(totalDone: container.data?.totalDone ?? -1, totalCancel: container.data?.totalCancel ?? -1, averageTime: container.data?.averageTime ?? -1)
                    self?.report = generatedReport
                    print("HERE IT IS")
                    print(generatedReport)
                }
            }
            
            print(container)
        }
        catch {
            
            print("Error")
        }
        
    }
    
    
    
}
