//
//  BusinessServiceViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/30/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class BusinessServicesViewModel: ObservableObject {
    
    //MARK: Model
    @Published var categories = [Category]() {
        didSet {
            print(categories)
        }
    }
    
    //MARK: Intent(s)
    func addCategory(name: String , price: Double) {
        
        //Check if the category exists already
//        var category = Category(title: name, image: )
//        categories.append(category)
        
        
    }
    
    
    func removeCategory(at index: Int) {
        categories.remove(at: index)
    }
}
