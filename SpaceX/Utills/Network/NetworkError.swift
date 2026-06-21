//
//  NetworkError.swift
//  SpaceX
//
//  Created by Ary on 6/21/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badRequest
    case invalidServerResponse
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
            
        case .badRequest:
            return "Bad Request"
            
        case .invalidServerResponse:
            return "Invalid server response"

        }
    }

    
}
