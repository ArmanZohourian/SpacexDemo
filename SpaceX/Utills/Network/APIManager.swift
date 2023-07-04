//
//  APIManager.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/25/22.
//

import Foundation


protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol, authToken: String) async throws -> Data
}

/// API Manager which conforms to APIMAnagerProtocol
/// create a url session with the given Reqeust (contains all the attributes including body, method etc ) using perform function
/// and the given auth token if needs one
/// the urlsession is an asynchronous one Using async , await and try to fetch the data and throws if there's any error
/// the output is the data returned by server if successfull otherwise throws an error
class APIManager: APIManagerProtocol {
    
    private let urlSession: URLSession
    
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: RequestProtocol, authToken: String) async throws -> Data {
            
    
        let (data, response) = try await urlSession.data(for: request.createURLRequest(authToken: authToken))
        
        print(response)
        print("Here is the data")
        print(String(data: data, encoding: .utf8))
        return data
    }
    
}
