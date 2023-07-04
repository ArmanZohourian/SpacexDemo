//
//  OTPViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/12/22.
//

import SwiftUI

/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class OTPViewModel: ObservableObject {
    
    
    
    
    
    
    @Published var otpFields: [String] = Array(repeating: "", count: 4)
    @Published var isReceived = false
    @Published var primaryToken = ""
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var isRequesting = false
    
    let language = LocalizationService.shared.language
    
    private let requestManager = RequestManager()
    
    
    func verifyPhonenumber(verificationKey: String, otp: String, phoneNumber: String) async {

        
        guard otpFields.joined().count == 4 else {
            throwError(errorMessage: "enter_otp_code".localized(language))
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        
        
        do {
            let registerContainer: RegisterModel = try await requestManager.perform(VerifyPhonenumber.verify(verificationKey: verificationKey, otpCode: otp, phoneNumber: phoneNumber))
            
            if registerContainer.status {
                DispatchQueue.main.async { [weak self] in
                    self?.isReceived = true
                    self?.isRequesting = false
                    UserDefaults.standard.setToken(value: registerContainer.data?.token ?? "")
                    UserDefaults.standard.setLoggedIn(value: true)
                    
                    
                }
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    self?.throwError(errorMessage: registerContainer.msg)
                    self?.isRequesting = false
                }
            }
        }
        
        catch {
            
            DispatchQueue.main.async { [weak self] in
                self?.throwError(errorMessage: "unable_to_conenct_to_server".localized(LocalizationService.shared.language))
                self?.isRequesting = false
            }
            
        }
        
    }
    
    func resendCode(with phoneNumber: String, countryCode: String, isResendCode: Bool, isRecovery: Bool) async  {
        //Check intennect
        
       
        do {
            
            let registerContainer : RegisterModel  =
            try await requestManager.perform(isRecovery ? RecoverPasswordWithPhoneNo.recover(phoneNumber: countryCode + phoneNumber) : VerificationRequest.getVeirificationCode(phoneNumber: countryCode + phoneNumber))
            
            if registerContainer.status {
                //let's go to the other view
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.isRequesting = false
                    
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
                self?.errorMessage = "unknown_error".localized(LocalizationService.shared.language)
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
