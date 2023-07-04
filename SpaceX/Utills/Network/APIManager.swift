//
//  APIManager.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation
protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol, authToken: String) async throws -> Data
}

class APIManager: APIManagerProtocol {
    
    private let urlSession: URLSession
    
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: RequestProtocol, authToken: String) async throws -> Data {
            
    
        let (data, response) = try await urlSession.data(for: request.createURLRequest(authToken: authToken))
        
        #if DEBUG
        print(response)
        #endif
        return data
    }
    
}
