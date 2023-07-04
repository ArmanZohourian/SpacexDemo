//
//  BusinessInformationViewModel.swift
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
class BusinessInformationViewModel: BaseViewModel {
    
    
    var language = LocalizationService.shared.language
    
    private var requestManager = RequestManager.shared
    private var isValidated = false
    
    @Published var isReceived = false
    @Published var choosenCity: City = City(id: 0, cityName: "", cityNameFa: "", provinceName: "", provinceNameFa: "")
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var isRequesting = false
    
    
    
    @Published var nameHasError = false
    @Published var identifierIdHasError = false
    @Published var addressHasError = false
    @Published var cityIdHasError = false
    @Published var contactInfoHasError = false
    
    @Published var nameErrorMessage = ""
    @Published var identifierIdErrorMessage = ""
    @Published var addressErrorMessage = ""
    @Published var cityIdErrorMessage = ""
    @Published var contactInfoErrorMessage = ""
    
    
    
    
    
    
    func submitBusinessInfo(name: String, identifierId: String, address: String, location: String?, cityId: String, contactInfo: String) async {
        
        
        validateFields(name: name, identifierId: identifierId, address: address, location: nil, cityId: cityId, contactInfo: contactInfo)
        
        
        guard isValidated == true else {
            throwError(errorMessage: "check_fields".localized(language))
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        
        do {
            
            let resultContainer: BusinessInformationResponse = try await
            requestManager.perform(BusinessInformationNetwork.submitBusinessInformation(name: name, identifierId: identifierId, address: address, location: location ?? "", cityId: cityId, contactInfo: contactInfo))
            
            
            if resultContainer.status {
                
                DispatchQueue.main.async { [weak self] in
                    self?.isReceived = true
                    self?.isRequesting = false
                    
                    
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.hasError = true
                    self?.errorMessage = resultContainer.msg ?? ""
                    self?.isRequesting = false
                }
                
            }
            
        } catch {
            
            throwError(errorMessage: nil)
            isRequesting = false
        }
        
    }
    
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
    
    private func validateFields(name: String, identifierId: String, address: String, location: String?, cityId: String, contactInfo: String) {
        
        if !isFieldValid(with: name) {
            
            nameHasError = true
            nameErrorMessage = "name_error".localized(language)
            isValidated = false
        }
        
        if !isFieldValid(with: identifierId) {
            identifierIdHasError = true
            identifierIdErrorMessage = "certificate_error".localized(language)
            isValidated = false
        }
        
        if !isFieldValid(with: address) {
            addressHasError = true
            addressErrorMessage = "address_error".localized(language)
            isValidated = false
        }
        
        
        if cityId == "0" {
            cityIdHasError = true
            cityIdErrorMessage = "city_error".localized(language)
            isValidated = false
        }
        
        if !isFieldValid(with: contactInfo) {
            contactInfoHasError = true
            contactInfoErrorMessage = "tel_error".localized(language)
            isValidated = false
            return
        }
        
        
        isValidated = true
        
    }
    
}
