//
//  LaunchesSrouce.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/1/23.
//

import Foundation

class LaunchesDataSource {
    
    static let shared = LaunchesDataSource() // Singleton
    
    @Published var alllaunches = [Doc]()
    
}
