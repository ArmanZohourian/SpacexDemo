//
//  GetServicesViewModel.swift
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
class ServicesViewModel: ObservableObject {
    
    var language = LocalizationService.shared.language
    
    @Published var isRequesting = false
    
    @Published var hasError = false
    
    @Published var errorMessage = ""
    
    private var requestManager = RequestManager.shared
    
    @Published var services = [Service]()
    
    @Published var categories = [Category]() {
        didSet {
            print("Here are photos:")
            print(categories)
        }
    }
    
    @Published var selectedCategory : Category?
    
    
    //MARK: Functionalities
    func getServices() async {
        
        
        do {
         
            let container: ServicesResponse = try await requestManager.perform(GetServices.getServices)
        
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    
                    var parentList = [Category]()
                    
                    for data in container.data {
                        if data.parentId == nil {
                            
                            parentList.append(Category(title: data.name, image: data.imageName, subCategory: [SubCategory](), isActive: data.activate, serverId: data.id))
                            
                        }
                  
                    }
                    
                    for index in parentList.indices {
                        for data in container.data {
                            if data.parentId == parentList[index].serverId {
                                parentList[index].subCategory!.append(SubCategory(serverId: data.id, name: data.name, price: String(data.cost ?? 0), image: data.imageName, isActive: data.activate))
                            }
                        }
                    }
                    self?.categories = parentList
   
                    print("HERE IT IS")
                }
            }
            
            print(container)
        }
        catch {
            
            print("Error")
        }
        
    }
    
    
    func submitCategory(with image: UIImage , params: [String:String], category: Category?, subCategory: SubCategory?) {
        
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        guard imageData != nil else {
            print("Show add Image error")
            return
        }
        
        let categoryResponse = MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: imageData!, params: params,  methodType: "POST", container: CategoryResponse.self, requeiresTokenAccess: true, userCompletionHandler: {response, error, success in
            
            
            if success {
                if response!.status {

                    DispatchQueue.main.async { [weak self] in
                        self?.isRequesting = false
                        
                    }
                }
            }
                
        })
        
    }
    
    
    //MARK: Intent(s)

    func uploadCategory(with image: UIImage , params: [String:String], category: Category?, subCategory: SubCategory?) {
        
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        
        MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: imageData, params: params,  methodType: "POST", container: CategoryResponse.self, requeiresTokenAccess: true, userCompletionHandler: {response, error, success in
            
            if success {
                if response!.status {
                    
                    //Set is requesting to false
            
                }
            }
                
        })
        
    }
    
    func uploadSubCategory(with image: UIImage , params: [String:String], category: Category, subCategory: SubCategory, completionHandler: @escaping (Bool) -> Void) {
        
        
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
//        guard imageData != nil else {
//            print("Show add Image error")
//            return
//        }
        isRequesting = true
        
        let categoryResponse = MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: nil, params: params,  methodType: "POST", container: CategoryResponse.self, requeiresTokenAccess: true, userCompletionHandler: {response, error, success in
            
            if success {
                if response!.status {
                    
                    DispatchQueue.main.async {[weak self] in
                        self?.isRequesting = false
                        completionHandler(true)
                    }
                }
            }
                
        })
        
    }
    
    func editCategory(with image: UIImage, category: Category?, changedCategory: Category, completionHandler: @escaping (Bool) -> Void) {
        
        
        guard changedCategory.title != "" else {
            throwError(errorMessage: "enter_service_name".localized(language))
            return
        }
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }

        MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: imageData , params: ["name" : changedCategory.title,
                                                                                                                                                            "activate" : "true",
                                                                                                                                                           "id" : String(category!.serverId)
                                                                                                                                     ],  methodType: "PUT", container: EditCategoryResponse.self, requeiresTokenAccess: true, userCompletionHandler: {response, error, success in
            if success {
                if response!.status {
                    
                        self.isRequesting = false
                    completionHandler(true)

                    
                } else {
                    self.isRequesting = false
                }
            } else {
                self.isRequesting = false
            }
                
        })
        
        
    }
    
    func editSubCategory(with image: UIImage, params: [String:String], category: Category, subCategory: SubCategory) {
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        let categoryResponse = MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: imageData, params: params,  methodType: "PUT", container: CategoryResponse.self, requeiresTokenAccess: true, userCompletionHandler: {response, error, success in
            
            if success {
                if response!.status {
                   
                    DispatchQueue.main.async { [weak self] in
                        self?.isRequesting = false
                    }
                    
                }
            }
                
        })
        
    }
    
    
    func deleteCategory(with category: Category) async {
        
        
        do {
            let container : GlobalRespone = try await requestManager.perform(DeleteCategory.deleteCategory(id: String(category.serverId)))
            
            if container.status {
                
                //Do nothing
                await getServices()
                
            } else {
                throwError(errorMessage: container.msg)
            }
        }
        
        catch {
            throwError(errorMessage: "Unable to connect to server")
        }
        
        
    }
    
    
    func deleteSubCategory(with subCategory: SubCategory) async {
        
        do {
            let container : GlobalRespone = try await requestManager.perform(DeleteSubCategory.deleteSubCategory(id: String(subCategory.serverId)))
            
            if container.status {
                // Do nothing
            } else {
                throwError(errorMessage: container.msg)
            }
        }
        
        catch {
            throwError(errorMessage: "Unable to connect to server")
        }
        
    }
    
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
    
    
}
