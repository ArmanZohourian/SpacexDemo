//
//  NetworkManager.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation
protocol RequestProtocol {
    
    
    var path: String { get }
    
    var headers: [String: String] { get }
    var params: [String : Any] { get }
    
    var urlParams: [String: String?] { get }
    
    var addAuthorizationToken: Bool { get }
    
    var reuqestType: RequestType { get }
    
}

enum RequestType: String {
    
    case GET
    case POST
    case PUT
    case DELETE
    
}

extension RequestProtocol {
    
    
    var host: String {
        return  APIConstanst.host
    }
    
    var addAuthorizationToken: Bool {
        true
    }
    
    
    var params: [String: Any] {
        [:]
    }
    
    var urlParams: [String: String?] {
        [:]
    }
    
    var headers: [String: String] {
        [:]
    }
    
    func createURLRequest(authToken: String) throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }

        let queryItems: [URLQueryItem] = components.queryItems ?? []
        components.queryItems = queryItems

        var urlReqeust = URLRequest(url: components.url!)
        urlReqeust.httpMethod = reuqestType.rawValue
        
        if !headers.isEmpty {
            urlReqeust.allHTTPHeaderFields = headers
        }
        
        if addAuthorizationToken {
            urlReqeust.setValue(authToken, forHTTPHeaderField: "Authorization")
        }
        
        urlReqeust.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !params.isEmpty {
            
            let body =  try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
            print(body)
            urlReqeust.httpBody = body
        }
        return urlReqeust
    }
    
    
}

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
            
        default:
            return "Unknown Error"
        }
    }

    
}
