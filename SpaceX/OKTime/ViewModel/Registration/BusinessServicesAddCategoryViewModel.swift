//
//  BusinessServicesAddCategoryViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/6/22.
//

import Foundation
import UIKit

/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await

class BusinessServiceAddCategoryViewModel: ObservableObject {
    
    
    @Published var errorMessage = ""
    
    @Published var hasError = false
    
    @Published var isRequesting = false
    
    @Published var isNotCategoryAdded: Bool = true
    
    @Published var selectedCategory: Category?
    
    @Published var selectedSubCategory: SubCategory?
    
    
    var language = LocalizationService.shared.language
    
    private var requestManager = RequestManager.shared
    
    
    @Published var categories = [Category]() {
        didSet {
            if categories.count > 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.isNotCategoryAdded = false
                }
                
            }
            
            if let existingSelectedCategory = selectedCategory {
                let existingIndex = categories.firstIndex { category in
                    category.serverId == existingSelectedCategory.serverId
                    
                }
                
                selectedCategory = categories[existingIndex!]
    
            }
            
        }
    }
    
    
    
    //MARK: Intent(s)
    
    func checkIfHasNotAddedCategory() {
        if categories.count == 0 {
//            throwError(errorMessage: "Add at least one category")
        }
    }
    
    

    
    //MARK: Requests
    
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
                                parentList[index].subCategory!.append(SubCategory(serverId: data.id, name: data.name, price:  String(data.cost ?? 0), image: data.imageName, isActive: data.activate))
                            }
                        }
                    }
                    self?.categories = parentList

                }
            }
            
        }
        catch {
            
            print("Error")
            throwError(errorMessage: "Unable to connect to server")
        }
        
    }
    
    func uploadCategory(with image: UIImage, categoryName: String, subCategory: SubCategory?, completionHandler: @escaping (Bool) -> Void) {
        
        
        guard categoryName != "" else {
            throwError(errorMessage: "enter_service_name".localized(language))
            return
        }
        
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
    
        MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: imageData , params: ["name" : categoryName,
                                                                                                                                                            "activate" : "true"
                                                                                                                                     ],  methodType: "POST", container: CategoryResponse.self, requeiresTokenAccess: true, userCompletionHandler: {response, error, success in
            
            if success {
                if response!.status {
                    
                    DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                    }
                    completionHandler(true)

                    
                } else {
                    self.isRequesting = false
                }
            } else {
                completionHandler(false)
                
                DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                    self?.throwError(errorMessage: "Unable to upload the category!")
                }
                
            }

        })
        
    }
    
    func uploadSubCategory(with image: UIImage , params: [String:String], category: Category, subCategory: SubCategory, completionHandler: @escaping (Bool) -> Void) {
        
        
        guard subCategory.name != "" else {
            throwError(errorMessage: "enter_service_name".localized(language))
            return
        }
        
        guard subCategory.price != "" else {
            throwError(errorMessage: "enter_price".localized(language))
            return
        }
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        isRequesting = true
        
        MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: imageData, params: params,  methodType: "POST", container: CategoryResponse.self, requeiresTokenAccess: true, userCompletionHandler: { response, error, success in
            
            
            if success {
                if response!.status {
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.isRequesting = false
                        
                    }
                    completionHandler(true)
                    
                } else {
                    self.isRequesting = false
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                    self?.throwError(errorMessage: "unable_to_connect_server".localized(LocalizationService.shared.language))
                    completionHandler(false)
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
                DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                    self?.throwError(errorMessage: "unable_to_connect_server".localized(LocalizationService.shared.language))
                    completionHandler(false)
                }
            }
                
        })
        
        
    }
    
    func editSubCategory(with image: UIImage, name: String, price: String, category: Category, subCategory: SubCategory , completionHanlder: @escaping (Bool) -> Void) {
        
        
        guard name != "" else {
            throwError(errorMessage: "Enter subcategory name")
            return
        }
        
        
        guard price != "" else {
            throwError(errorMessage: "Enter subcategory price")
            return
        }
        
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        
        
        
        isRequesting = true
        
        MultipartFromRequest(path: "/api/v1/business/available-service").uploadImage(name: "logo", image: imageData, params: ["name" : name,
                                                                                                                                     "activate:": "true",
                                                                                                                                     "cost" : price,
                                                                                                                                     "id" : String(subCategory.serverId)] ,  methodType: "PUT", container: GlobalRespone.self, requeiresTokenAccess: true, userCompletionHandler: {response, error, success in
            
            if success {
                if response!.status {
                    
                    self.isRequesting = false
                    completionHanlder(true)
                    
                } else {
                    self.isRequesting = false
                    completionHanlder(true)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                    self?.throwError(errorMessage: "unable_to_connect_server".localized(LocalizationService.shared.language))
                    completionHanlder(false)
                }
            }

        })
        
    }
    
    func deleteCategory(with category: Category) async {
        
        
        do {
            let container : GlobalRespone = try await requestManager.perform(DeleteCategory.deleteCategory(id: String(category.serverId)))
            
            if container.status {
                
                //Do nothing
                
                
            } else {
                throwError(errorMessage: container.msg)
            }
        }
        
        catch {
            throwError(errorMessage: "unable_to_conenct_server".localized(LocalizationService.shared.language))
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
            throwError(errorMessage: "unable_to_connect_server".localized(LocalizationService.shared.language))
        }
        
    }
    
    func updateSubCategoryStatus(with subCategory: SubCategory, status: Bool) async {
        
        do {
            //Send the request
            let container: GlobalRespone = try await requestManager.perform(UpdateSubcategory.withStatus(id: subCategory.serverId, status: status))
            
            if container.status {
                print("Successfull")
            } else {
                throwError(errorMessage: "unable_to_connect_server".localized(LocalizationService.shared.language))
            }
            
            
        } catch {
            
        }
        
        
    }
    
    func updateCategoryStatus(with category: Category, status: Bool) async {
        
        do {
            //Send the request
            let container: GlobalRespone = try await requestManager.perform(UpdateCategory.withStatus(id: category.serverId, status: status))
            
            if container.status {
                print("Successfull")
            } else {
                throwError(errorMessage: "unable_to_connect_server".localized(LocalizationService.shared.language))
            }
            
            
        } catch {
            
        }
        
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
}
