//
//  ServiceViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/22.
//
//MARK: GET RID OF THIS ...
import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class ServiceViewModel: ObservableObject {
    
    private var requestManager = RequestManager.shared
    
    @Published var services = [Service]() {
        
        didSet {
            print("SERVICE IS BEING PRINTED")
            print(services)
        }
    }
    
    func getServices() async {
        
        do {

            let container: ServiceServerModel = try await requestManager.perform(GetServices.getServices)
            
            if container.status {
                
                DispatchQueue.main.async { [weak self] in
                    for service in container.data {
                        
                        let newService = Service(parentId: service.parentId, id: service.id, estimatedTime: service.estimatedTime, activate: service.activate, imageName: service.imageName, name: service.name)
                        self?.services.append(newService)
                        
                    }
                    
                }

//                print("Here are the cities: \(container.data)")
            }
        }
        catch let erorr {
            print(erorr)
            print("throw the error")
        }
        
    }
    
    
}
