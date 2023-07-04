//
//  BusinessInfoViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/21/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class BusinessInfoViewModel: ObservableObject {
     
    @Published var businessInfo : BusinessInfo?
    
    private var requestManager = RequestManager.shared
    
    
    func getBusinessInfo() async {
        
        do {
            
            let container : BusinessInfoResponse = try await requestManager.perform(GetBusinessInfo.getBusinessInformation)
            
            if container.status {
                
                businessInfo = container.data[0]
            }
            
        }
        
        catch {
            
            print("Error")
            
        }
    }
    
    
}
