//
//  RegisterViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/29/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class BusinessRegister: BaseViewModel  {
    
    
    var language = LocalizationService.shared.language
    
    @Published var isReceived = false
    @Published var isRequesting = false
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var isValitaded = false
    
    @Published var firstNameError = ""
    @Published var firstNameHasError = false
    
    @Published var lastNameError = ""
    @Published var lastNameHasError = false
    
    @Published var sexError = ""
    @Published var sexHasError = false

    @Published var passwordError = ""
    @Published var passwordHasError = false
    
    @Published var repeatPasswordError = ""
    @Published var repeatPasswordHasError = false
    


    private let requestManager = RequestManager()
    
    func registerUser(firstName: String, lastName: String, sex: String, password: String, repPassword: String, token: String) async {
        
        
        //MARK: Check the criedintials
        checkFieldsValidation(with: firstName, lastName: lastName, sex: sex, password: password, repeatedPassword: repPassword)
        
        guard isValitaded == true else {
            return
        }
        
        guard password == repPassword else {
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
        
        
        //Send  Request
        do {
            let resultContainer: RegisterModel = try await requestManager.perform(Register.registerBusiness(firstName: firstName, lastName: lastName, gender: sex, password: password))
            
            if resultContainer.status {
                DispatchQueue.main.async { [weak self] in
                    
                    //Cache the primary token into the userdefualts
                    self?.isReceived = true
                    self?.isRequesting = true
                }
                print(resultContainer)
            } else {
                print(resultContainer)
                DispatchQueue.main.async { [weak self] in
        
                    self?.hasError = true
                    self?.errorMessage = resultContainer.msg ?? ""
                    
                }
            }
        } catch {
            
            throwError(errorMessage: nil)
        }
        
        
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
    
    private func checkFieldsValidation(with firstName: String , lastName: String, sex: String, password: String, repeatedPassword: String) {
        
        
        if firstName == "" {
            firstNameError = "enter_firstname_error".localized(language)
            firstNameHasError = true
            isValitaded = false
        }
        
        if lastName == "" {
            lastNameError = "enter_lastname_error".localized(language)
            lastNameHasError = true
            isValitaded = false
        }
        
        if sex == "" {
            sexError = "sex_selection_error".localized(language)
            sexHasError = true
            isValitaded = false
        }
        
        if password == "" {
            passwordError = "enter_password_error".localized(language)
            passwordHasError = true
            isValitaded = false
            
        }
        
        if repeatPasswordError == "" {
            repeatPasswordError = "enter_password_error".localized(language)
            repeatPasswordHasError = true
            isValitaded = false
            return
        }
        
        isValitaded = true
        
        
    }
    
}
