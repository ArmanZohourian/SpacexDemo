//
//  CacheManager.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import Foundation
import UIKit

class ImageCache {
    
    
    typealias CacheType = NSCache<NSString, NSData>
    static let shared = ImageCache() // Singleton
    private init() {}

    var imageCache : NSCache<NSString, NSData> = {
        let cache =  CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 0
        return cache
    }()
    
    
    func getObject(forkey key: NSString) -> Data? {
        imageCache.object(forKey: key) as? Data
    }
    
    func set(object: NSData ,forKey key: NSString) {
        imageCache.setObject(object, forKey: key)
    }
    
    
}
