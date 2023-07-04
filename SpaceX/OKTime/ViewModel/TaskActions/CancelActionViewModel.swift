//
//  CancelActionViewModel.swift
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
class CancelActionViewModel: ObservableObject {
    
    
    private var requestManager = RequestManager.shared
    
    func cancelAction(id: Int) async {
        
        do {
         
            let container : StartActionResponse = try await requestManager.perform(CancelAction.cancelAction(id: id))
            
            
            
        }
        catch {
            
            print("Error")
            
        }
        
    }
    
}
