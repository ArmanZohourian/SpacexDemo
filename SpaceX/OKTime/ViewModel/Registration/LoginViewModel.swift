//
//  LoginViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/16/22.
//

import Foundation

/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class LoginViewModel: BaseViewModel {
    

    let language = LocalizationService.shared.language
    
    var accesstoken = ""
    
    let tokenKey = "token"

    @Published var isSignedin = false
    
    @Published var hasError = false
    
    @Published var errorMessage : String = ""
    
    @Published var isReceived = false
    
    @Published var selection : String? = nil
    
    @Published var isRequesting = false
    
    //MARK: Singin Credentials
    var phoneNumber : String = ""
    
    //MARK: Intent(s)
    private let requestManager = RequestManager()
    
    
    func VerifyPhoneNumber(with phoneNumber: String, countryCode: String, isResendCode: Bool) async  {
        //Check intennect
        
        

        if !isResendCode {
            guard !phoneNumber.isEmpty else {
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.hasError = true
                    self?.isRequesting = false
                    self?.errorMessage = "enter_phone_number".localized(LocalizationService.shared.language)
                    
                }
                
                return
            }
        }
        
        
        
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        self.phoneNumber = phoneNumber
       
        do {
            
            let registerContainer : RegisterModel  =
            try await requestManager.perform(VerificationRequest.getVeirificationCode(phoneNumber: countryCode + phoneNumber))
            
            if registerContainer.status {
                //let's go to the other view
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.accesstoken =  registerContainer.data?.token ?? ""
                    self?.isReceived = true
                    self?.isRequesting = false
                    if !isResendCode {
                        self?.selection = registerContainer.data?.action ?? ""
                    }
                    
                }
                
                if isResendCode {
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.throwError(errorMessage: "Code has been sent to you")
                    }
                }
                
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.hasError = true
                    self?.errorMessage = registerContainer.msg ?? "Nothing"
                    self?.isRequesting = false
                    
                }
            }
        } catch {
            
            DispatchQueue.main.async { [weak self] in
                self?.isRequesting = false
                self?.hasError = true
                self?.errorMessage = "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
            }
        }
        

        
        
    }
     
    func loginWithPassword(phoneNumber: String, password: String, completionHandler: @escaping (Bool) ->()) async {
        
        
        guard password != "" else {
            throwError(errorMessage: nil)
            return
        }
        
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
            
        }
        
        do {
            let container: LoginPasswordResponse = try await requestManager.perform(VerifyPassword.verifyPassword(phoneNumber: phoneNumber, password: password))
            
            if container.status {
                
                
                DispatchQueue.main.async { [weak self] in
//                    self?.selection = "REGISTER"
                    self?.accesstoken = container.data!.token
                    self?.saveToken(container.data!.token)
                    UserDefaults.standard.setToken(value: container.data!.token)
                    UserDefaults.standard.setLoggedIn(value: true)
                    self?.isRequesting = false
                    self?.isReceived = true
                    completionHandler(true)
    
                }
                
            } else {
                throwError(errorMessage: container.msg)
                DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                }
            }
            
        } catch {
            throwError(errorMessage: nil)
        }
        
    }
    
    private func saveToken(_ token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: tokenKey)
        print("Token has been saved\(userDefaults.object(forKey: tokenKey) ?? "")")
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
    
    
    
}
     

