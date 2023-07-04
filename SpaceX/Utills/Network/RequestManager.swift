//
//  RequestManager.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation
protocol RequestManagerProtocol {
    func perform<T: Codable>(_ request: RequestProtocol) async throws -> T
}

class RequestManager: RequestManagerProtocol {
    
    
    static let shared = RequestManager()
    
    func perform<T>(_ request: RequestProtocol) async throws -> T where T : Decodable, T : Encodable {
        
        let data = try await apiManager.perform(request, authToken: UserDefaults.standard.getToken())
        
        let decoded: T = try parser.parser(data)
        return decoded
        
    }
    
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    
    init(apiManager: APIManager = APIManager(), parser: DataParserProtocol = DataParser())  {
        self.apiManager = apiManager
        self.parser = parser
    }
}
