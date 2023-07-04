//
//  RequestManager.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/25/22.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Codable>(_ request: RequestProtocol) async throws -> T
}

///Reuqest manager
///Perform Fucntion : Given the configured request it will use the api manager to
///use the created urlsession to perfom a urlrequest
///fetching the auth token if needed and saved on the UserDefaults
///if the request is succsessfull it will pass the data to the parser to decode the data
///to the given model
///T : Reperesnts a generic model that conforms to Codable ( Decodable and Encodable)
///in the the out put would be the parsed data ready to be used in the view model

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
