//
//  CityViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/6/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class CityViewModel: ObservableObject {
    
    
    @Published var cities : [City]?
    
    private var requestManager = RequestManager.shared
    
    func getCities(with name: String) async {
        
        do {

            let container: RegisterModel = try await requestManager.perform(GetCities.getAllCities(name: name))

            if container.status {
                print("Here are the cities: \(container.data)")
                cities = [City]()
                if let cities = container.data?.cities {
                    for city in cities {
                        self.cities!.append(City(id: city.id, cityName: city.cityName, cityNameFa: city.cityNameFa, provinceName: city.provinceName, provinceNameFa: city.provinceNameFa))
                    }
                }
            }
        }
        catch let error {
            print(error)
            print("throw the error")
        }
        
    }
    
    
    
}
