//
//  ResetPasswordViewModel.swift
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
class ResetPasswordViewModel: ObservableObject {
    
    private var language = LocalizationService.shared.language
    
    private var requestManager = RequestManager.shared
    
    @Published var errorMessage = ""
    @Published var hasError = false
    
    func resetPassword(oldPassword: String, newPassword: String, repeatedPassword: String, completionHandler: @escaping (Bool) -> ()) async {
        
        guard oldPassword != "" else {
            throwError(errorMessage: "enter_password".localized(language))
            return
        }
        
        guard repeatedPassword != "" else {
            throwError(errorMessage: "repeat_your_password".localized(language))
            return
        }
        
        guard newPassword != "" else {
            throwError(errorMessage: "enter_your_new_password".localized(language))
            return
        }
        
        guard newPassword == repeatedPassword else {
            throwError(errorMessage: "password_not_match".localized(language))
            return
        }
        
        
        do {
            
            let container : ResetPasswordResponse = try await requestManager.perform(ResetPassword.resetPassword(oldPassword: oldPassword, newPassword: newPassword))
            
            DispatchQueue.main.async { [weak self] in
                if container.status {
                    self?.throwError(errorMessage: "password_change_successful".localized(LocalizationService.shared.language))
                    completionHandler(true)
                    
                } else {
                    self?.throwError(errorMessage: container.msg ?? nil)
                }
            }

            
        }
        
        catch {
            
            print("Error")
            throwError(errorMessage: nil)
    
        }
        
        
        
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }

    
    
}
