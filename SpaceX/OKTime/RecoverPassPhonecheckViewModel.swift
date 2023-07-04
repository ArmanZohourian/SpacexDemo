//
//  RecoverPasswordVm.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/3/22.
//

import Foundation
class RecoverPasswordViewModel: ObservableObject {
    
    private var requestManager = RequestManager()
    
    @Published var isReceived = false {
        didSet {
            print("Is Received is : \(isReceived)")
        }
    }
    @Published var hasError = false
    @Published var errorMessage = ""
    
    
    var accessToken = ""
    
    func recoverPassword(with phoneNumber: String) async {
        
        do {
            
            let registerContainer : RegisterModel = try await requestManager.perform(RecoverPasswordWithPhoneNo.recover(phoneNumber: phoneNumber))
            
            print("The Password Revovery is:\(registerContainer)")
            DispatchQueue.main.async {[weak self] in
                if registerContainer.status {
                    self?.isReceived = true
                    self?.accessToken = registerContainer.data?.token ?? ""
                } else {
        
                    self?.hasError = true
                    self?.errorMessage = registerContainer.msg ?? "Nothing"
                    
                }
            }
            
        }
        catch {
            
        }
        
    }
    
}
