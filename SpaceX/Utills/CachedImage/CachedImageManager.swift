//
//  CacheImage.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import Foundation

final class CachedImageManager: ObservableObject {

    @Published private(set) var  data : Data?
    
    private let imageFetcher = ImageFetcher.shared
    
    
    @MainActor
    func load(_ imageUrl: String, cache: ImageCache = .shared) async {
        
        if let imageData = cache.getObject(forkey: imageUrl as NSString) {
            
            self.data = imageData
            #if DEBUG
            print("Fetching the image from the cache!📲")
            #endif
            return
        }
        do {
            self.data = try await imageFetcher.fetch(imageUrl)
            if let dataToCache = data as? NSData {
                cache.set(object: dataToCache, forKey: imageUrl as NSString)
            }
        }
        catch {
            print(error)
        }
    }

    
}

