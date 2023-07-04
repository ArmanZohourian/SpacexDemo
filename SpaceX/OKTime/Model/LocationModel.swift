//
//  LocationModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/5/22.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    
    
    var id = UUID()
    let coordinate: CLLocationCoordinate2D
    
}
