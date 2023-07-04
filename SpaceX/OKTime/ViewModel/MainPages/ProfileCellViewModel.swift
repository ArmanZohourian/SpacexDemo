//
//  ProfileCellViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/4/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class ProfileCellViewModel: ObservableObject {
    
    private var requestManager = RequestManager.shared
    
    @Published var userInformation : UserProfileInformation?
    
    @Published var businessInformation: BusinessInformation?
    
    func getUserInfo() async {
        
        do {
         
            let container: UserProfileResponse = try await requestManager.perform(GetUserInfo.getUserInformation)
        
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    
                    let userInfo = UserProfileInformation(firstName: container.data!.firstName, lastName: container.data!.lastName, gender: container.data!.gender, phoneNumber: container.data!.phoneNumber, avatar: container.data!.avatar)
                    
                    self?.userInformation = userInfo
                    
                    
                    
                }
            }
            print(container)
        }
        catch {
            
            print("Error")
        }
        
        
        
    }
    
    
    //For the sake of getting the business name only !
    func getBusinessInfo() async {
        
        
        do {
         
            let container: BusinessInfoWebResponse = try await requestManager.perform(GetBusinessInfo.getBusinessInformation)
        
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    
                    let userInfo = container.data
                    self?.businessInformation = userInfo
                    
                    
                    print("HERE IS BUSINESS")
                    
                }
            }
            print(container)
        }
        catch {
            
        }
        
        
        
    }
}
