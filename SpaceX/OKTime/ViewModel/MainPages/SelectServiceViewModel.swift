//
//  SelectServiceViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class SelectServiceViewModel: ObservableObject {
    
    private var requestManager = RequestManager.shared
    
    @Published var categories = [Category]()
    
    
    
    
    @Published var subCategories = [SubCategory]() {
        didSet {
            print("GENERATED SUBCATEGORIES")
            print(subCategories)
        }
    }
    
    @Published var filteredsubCategoires = [SubCategory]()
    
    //MARK: Functionalities
    func getServices() async {
        
        
        do {
         
            let container: ServicesResponse = try await requestManager.perform(GetServices.getServices)
        
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    
                    var parentList = [Category]()
                    
                    for data in container.data {
                        if data.parentId == nil {
                            
                            parentList.append(Category(title: data.name, image: nil, subCategory: [SubCategory](), isActive: data.activate, serverId: data.id))
                            
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
                    self?.generateSubCategories(with: parentList)
                    print("HERE IT IS")
                }
            }
            
            //From the fetched categories , generate the subcategories
            
        }
        catch {
            
            print("Error")
        }
        
    }
    
    
    private func generateSubCategories(with categories: [Category]) {
        //Adding the active subcategories to be shown to the user
        
        
        for category in categories {
            if category.isActive {
                if let subcategories = category.subCategory {
                    for subcategory in subcategories {
                        if subcategory.isActive {
                            let createdSubCategory = SubCategory(serverId: subcategory.serverId, name: subcategory.name, categoryName: category.title, price: subcategory.price,image: subcategory.image, isActive: subcategory.isActive)
                            self.subCategories.append(createdSubCategory)
                            self.filteredsubCategoires.append(createdSubCategory)
                        }
                    
                    }
                }
            }
        }
        
        
    }
    
    func searchServices(with searchText: String) {
        
        guard searchText != "" else {
            filteredsubCategoires = subCategories
            return
        }
        
        let filteredSubcategories = subCategories.filter { subcategory in
            subcategory.name.contains(searchText)
        }
        
        self.filteredsubCategoires = filteredSubcategories
    }
    
     func hasActiveService() -> Bool {
        if filteredsubCategoires.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    
    
}
