//
//  MultipartFormNetwork.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/2/22.
//

import Foundation


//// MultiPartFormRequest :
///creates a multiparform request with the given path
///uses upload image function with the given parameters (name , image (optional) , methodType , etc)
///Given the generic container of any type that conforms to decodable
///Configures the the multipart data and iterates throught the parameters that are given
///Finally adds the images data if given to the body and wraps it up and create the URLSession upload task to upload it
///Using userCompletionHandler so that the data and the response could be fetched by the view model, and be handled
///Decodes the data if successfull and returns it
struct MultipartFromRequest {
    
    private var httpBody = NSMutableData()
    var path: String
    var data = Data()
    
    init(path: String) {
        self.path = path
    }

    


    
    func uploadImage<T>(name: String , image: Data? , params: [String:String], methodType: String, container: T.Type, requeiresTokenAccess: Bool, userCompletionHandler: @escaping (T?, Error?, Bool) -> Void) where T: Decodable {
        
        
        let language = LocalizationService.shared.language
        
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstanst.host
        components.path = path
        
        
        let filename = "avatar.png"
        let boundary = UUID().uuidString
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 40.0
        let session = URLSession(configuration: config)

        //Language check
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
        
        
        var urlRequest = URLRequest(url: components.url!)
            urlRequest.httpMethod = methodType
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data in a web browser
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if requeiresTokenAccess {
            urlRequest.allHTTPHeaderFields = ["Authorization" : "Bearer \(UserDefaults.standard.getToken())"]
        }
        
        
        var data = Data()
        
        // Add the field name and field value to the raw http request data
        // put two dashes ("-") in front of boundary string to separate different field/values
  
        
        //MARK: Sending parameters
        for (key , value) in params {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)".data(using: .utf8)!)
            
        }


        
        // Add the image to the raw http request data, if given any
        if let imageData = image {
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        } else {
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
        }
         
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        //MARK: End of body
        session.uploadTask(with: urlRequest, from: data) { data, resp, err in
            
            
            //Decode data with the given model(generic) and update the id of category or subCategory.
            print(resp)
            
            if (err as? URLError)?.code == .timedOut {
                userCompletionHandler(nil, NetworkError.badRequest, false)
            }
            
            if resp == nil {
                userCompletionHandler(nil, NetworkError.badRequest, false)
            }
            
            if let httpResponse = resp as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard let fetchedData = data else { return }
                    let decoder = JSONDecoder()
                    
                    let response = try? decoder.decode(container.self , from: fetchedData)
                    print(response as Any)
                    if let responseContainer = response {
                        userCompletionHandler(responseContainer, nil, true)
                    }
                } else {
                    //Server failed to send a proper response
                    userCompletionHandler(nil, NetworkError.badRequest, false)
                    return
                }
            } else {
                userCompletionHandler(nil, NetworkError.badRequest, false)
            }
            

            
            

            
        }.resume()
    }

}
