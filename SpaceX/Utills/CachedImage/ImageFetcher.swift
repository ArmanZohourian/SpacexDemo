//
//  ImageFetcher.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import Foundation


//MARK: Protocol
protocol ImageFetcherProtocol {
    
    func fetch(_ imageUrl: String) async throws -> Data
    
}


//MARK: Struct
class ImageFetcher: ImageFetcherProtocol {
    
    
    static let shared = ImageFetcher() // Singleton
    
    func fetch(_ imageUrl: String) async throws -> Data {
        
        guard let url = URL(string: imageUrl) else {
            //throw error
            throw FetcherError.invadilUrl
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        
        return data
    }
    
    
}


//MARK: Extension
private extension ImageFetcher {
    enum FetcherError: Error {
        case invadilUrl
    }
}
