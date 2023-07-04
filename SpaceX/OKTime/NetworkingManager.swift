//
//  Network.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/24/22.
//


import Foundation

/// Request Protocol:
/// Contains the attributes needed for an HTTP request to be made ,
/// Each attribute has been set the will be initiated with a an extention
/// Request types are also an enum so it would more readable and conviniet to use them when initiating a reqeuest
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


/// Reqeust protocol extention initiates the Host
/// and has a function called createURLRequest which configures the URL Request
/// for the request that are needed to be verified and logged in user
/// the addAuthorization should be set to true
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
    
    
    /// Create the url request given the authorizationToken(if has one),
    /// configures the URL using URL Components ( scheme , path and the host),
    /// Adding the the query Items if given any,
    /// checking the language selected by the user to add the suitable query based on the language,
    /// setting the url headers and the authorization if needed,
    /// and appending the body since it is a json with the given parametes.
    func createURLRequest(authToken: String) throws -> URLRequest {
        
        
        let language = LocalizationService.shared.language
        
        
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        //Checking the language of app
        
        if language == .english {
            let languageQuery =  URLQueryItem(name: "lang", value: "en")
            if components.queryItems != nil {
                components.queryItems?.append(languageQuery)
            } else {
                var queryItems: [URLQueryItem] = components.queryItems ?? []
                queryItems.append(languageQuery)
                components.queryItems = queryItems
            }
        }
        
    

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


 ///Generated network errors
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
