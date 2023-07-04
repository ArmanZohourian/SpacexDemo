//
//  RegisterUserInfoViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import Foundation
import UIKit
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class RegisterUserInfoViewModel: ObservableObject {
    
    
    
    @Published var isRecieved = false
    
    @Published var errorMessage = ""
    
    @Published var userInformation : UserProfileInformation?
    
    @Published var isActivated: Bool = false
    
    @Published var choosenImage = UIImage()
    
    @Published var hasError = false
    
    private var requestManager = RequestManager.shared
    
    private var mulitPartReqeustManager = MultipartFromRequest(path: "/api/v1/users/user")
    
    func registerUserInfo(firstName: String, lastName: String, phoneNumber: String, imageData: Data?, completionHandler:  @escaping (Bool) ->()) {
        
        
        DispatchQueue.main.async { [weak self] in
            self?.isActivated = true
        }
        
        
        let params = ["first_name" : firstName,
                      "last_name" : lastName]
        
        mulitPartReqeustManager.uploadImage(name: "ProfilePic", image: imageData, params: params, methodType: "PUT", container: UserRegisterResponse.self, requeiresTokenAccess: true) { response, err, success in
            if success {
                DispatchQueue.main.async { [weak self] in
                    if response!.status {
                        self?.isActivated = false
                        self?.isRecieved = true
                        self?.errorMessage = "success_register_status".localized(LocalizationService.shared.language)
                        completionHandler(true)
                            
                    } else {
                        
                        self?.isActivated = false
                        self?.hasError = true
                        self?.errorMessage = "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
                        completionHandler(false)
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.hasError = true
                    self?.isActivated = false
                    self?.errorMessage = "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
                    completionHandler(false)
                    
                }
            }
            
            
        }
        
    }
    
    
    func getUserInfo() async {
        
        do {
         
            let container: UserProfileResponse = try await requestManager.perform(GetUserInfo.getUserInformation)
        
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    
                    let userInfo = UserProfileInformation(firstName: container.data!.firstName, lastName: container.data!.lastName, gender: container.data!.gender, phoneNumber: container.data!.phoneNumber, avatar: container.data!.avatar)
                    
                    self?.userInformation = userInfo
                    
                    print("HERE IT IS")
                    
                }
            }
            print(container)
        }
        catch {
            
            print("Error")
        }
        
        
        
    }
    
}
