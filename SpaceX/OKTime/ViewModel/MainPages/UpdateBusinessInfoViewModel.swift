//
//  BusinessInfoHamburgerViewModel.swift
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
class UpdateBusinessInfoViewModel: ObservableObject {
    
    
    var language = LocalizationService.shared.language
    
    @Published var choosenCity = City(id: -1, cityName: "", cityNameFa: "", provinceName: "", provinceNameFa: "") {
        didSet {
            print("Happening")
        }
    }
    
    @Published var isReceived = false
    
    @Published var isSuccessful = false
    
    @Published var hasError = false
    
    @Published var errorMessage = ""
    
    @Published var businessInfo: BusinessInformation?
    
    @Published var isRequesting: Bool = false
    
    private var requestManager = RequestManager.shared
    
 
    func updateBusinessInfo(name: String, identifierId: String, address: String, location: String?, cityId: String, contactInfo: String) async {
        
        guard name != "" else {
            
            throwError(errorMessage: "name_error".localized(language))
            return
            
        }
        
        guard identifierId != "" else {
            
            throwError(errorMessage: "certificate_error".localized(language))
            return
            
        }
        
        guard address != "" else {
            
            throwError(errorMessage: "address_error".localized(language))
            return
        }
        
        guard cityId != "" else {
            
            throwError(errorMessage: "city_error".localized(language))
            return
            
        }
        
        guard contactInfo != "" else {
            
            throwError(errorMessage: "tel_error".localized(language))
            return
            
        }
        
        do {
            
            DispatchQueue.main.async { [weak self] in
                self?.isRequesting = true
            }
            
            let resultContainer: UpdateBusinessInfoResponse = try await
            requestManager.perform(UpdateBusinessInfo.updateBusinessInfo(name: name, identifierId: identifierId, address: address, location: location ?? "", cityId: cityId, contactInfo: contactInfo))
            DispatchQueue.main.async { [weak self] in
                if resultContainer.status {
                    self?.isRequesting = false
                    self?.isSuccessful = true
                    self?.errorMessage = "operation_successful".localized(LocalizationService.shared.language)

                    
                } else {
                    self?.isRequesting = false
                    self?.errorMessage = resultContainer.msg ?? ""
                    
                }
            }
            
        }
        catch {
            
            
            DispatchQueue.main.async { [weak self] in
                self?.throwError(errorMessage: nil)
                self?.isRequesting = false
            }
            
            print("Error")
        }
    }
    
    func getBusinessInfo() async {
        
        
        do {
         
            let container: BusinessInfoWebResponse = try await requestManager.perform(GetBusinessInfo.getBusinessInformation)
        
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    
                    let userInfo = container.data
                    self?.businessInfo = userInfo
                    
                    
                    print("HERE IT IS")
                    
                }
            }
            print(container)
        }
        catch {
            self.throwError(errorMessage: "unable_to_conenct_to_server".localized(language))
        }
        
        
        
    }
    
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "check_fields".localized(LocalizationService.shared.language)
        }

    }
}

