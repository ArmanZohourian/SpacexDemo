//
//  RecoverPasswordVm.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/3/22.
//


/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
import Foundation
class RecoverPasswordViewModel: ObservableObject {
    
    
    
    private var requestManager = RequestManager.shared
    
    var language = LocalizationService.shared.language
    
    @Published var isReceived = false
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var isRequesting = false
    
    
    var accessToken = ""
    
    func recoverPassword(with phoneNumber: String) async {
        
        
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
            
        }
        
        guard phoneNumber != "" else {
            throwError(errorMessage: "enter_phone_number".localized(language))
            return
        }
        
        do {
            
            let registerContainer : RegisterModel = try await requestManager.perform(RecoverPasswordWithPhoneNo.recover(phoneNumber: phoneNumber))
            
            print("The Password Revovery is:\(registerContainer)")
            DispatchQueue.main.async {[weak self] in
                if registerContainer.status {
                    self?.isReceived = true
                    self?.accessToken = registerContainer.data?.token ?? ""
                    self?.isRequesting = false
                } else {
        
                    self?.hasError = true
                    self?.errorMessage = registerContainer.msg ?? "Nothing"
                    self?.isRequesting = false
                    
                }
            }
            
        }
        catch {
            
            isRequesting = false
            
        }
        
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
}
