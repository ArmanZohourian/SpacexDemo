//
//  EndActionViewModel.swift
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
class EndActionViewModel: ObservableObject {
    
    
    
    var error = "" {
        didSet {
            print(error)
        }
    }
    
    var language = LocalizationService.shared.language
    
    private var requestManager = RequestManager.shared
    
    func endAction(taskId: Int, price: String, startTime: Date, endTime: Date, paymentMethod: String) async {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "En")
        let startTimeStr = dateFormatter.string(from: startTime)
        let endTimeStr = dateFormatter.string(from: endTime)
        
        let costStr = (price as NSString).doubleValue
        
        
         var generatedPaymentMethod : String {
             

             if paymentMethod == "cash".localized(language) {
                return "CASH"
             } else if paymentMethod == "transfer".localized(language) {
                return "TRANSFER"
            } else if paymentMethod == "کارتخوان" {
                return "TRANSFER"
            }
             return ""
        }
        
        do {
         
            let container : StartActionResponse = try await requestManager.perform(EndAction.endAction(id: taskId, cost: costStr, startTime: startTimeStr, endTime: endTimeStr, paymentMethod: generatedPaymentMethod))
            
            error = container.msg ?? "عملیات با موفقیت انجام شد"
            
            print(container)
            
        }
        catch {
            
            print("Error")
            
        }
        
    }

    
    
}
