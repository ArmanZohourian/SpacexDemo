//
//  DataParser.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation
protocol DataParserProtocol {
    
    func parser<T: Codable>(_ data: Data) throws -> T
    
}

/// DataParses uses Json decoder to decode any given model that
/// confroms to Codable using the keyCoding stategy of snake cased ( based on the given data from the API)
/// and return the the given model decoded and ready to be used
class DataParser: DataParserProtocol {
    
    private var jsonDecoder: JSONDecoder
    
    
    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    func parser<T>(_ data: Data) throws -> T where T : Decodable, T : Encodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
