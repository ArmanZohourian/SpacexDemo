//
//  CreatePasswordViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/5/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class UpdatePasswordViewModel: BaseViewModel  {
    
    
    private var requestManager : RequestManager = RequestManager.shared
    
    
    @Published var isReceived : Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage = ""
    @Published var isRequesting : Bool = false
    
    var language = LocalizationService.shared.language
    
    func updatePassword(with password: String, repeatedPassword: String, accessToken: String) async {
        
        
        guard !password.isEmpty else {
            throwError(errorMessage: "enter_password_error".localized(language))
            return
        }
        
        guard password == repeatedPassword else {
            throwError(errorMessage: "password_not_match".localized(language))
            return
        }
        
        
        guard isPasswordValid(withPassword: password) == true else {
            throwError(errorMessage: "password_evaluation_error".localized(language))
            return
        }
        
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        //Send the req to server
        do {
            
            let registerContainer: RegisterModel = try await requestManager.perform(UpdatePassword.updatePasswordWith(newPassword: password, token: accessToken))
            print("The password recovery status:\(registerContainer)")
            if registerContainer.status  {
                DispatchQueue.main.async { [weak self] in
                    self?.isReceived = true
                    self?.isRequesting = false
                }
                print("Successful")
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    self?.throwError(errorMessage: registerContainer.msg)
                    self?.isRequesting = false
                    
                }
                

            }
            
            
        }
        
        catch {
            
            DispatchQueue.main.async { [weak self] in
                self?.isRequesting = false
            }
            
        }
        
        
    }
    
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
}
