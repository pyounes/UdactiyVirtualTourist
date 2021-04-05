//
//  TASKManager.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/4/21.
//

import Foundation

class TASKManager {
    
    enum Method: String {
        case post = "POST"
        case put  = "PUT"
        case get  = "GET"
        case del  = "DELETE"
    }
    
    class func taskHandler<ResponseType: Decodable, FailureType: Decodable>(
        url: URL
        ,method: Method
        ,responseType: ResponseType.Type
        ,failure: FailureType.Type
        ,completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)

        switch method {
        case .get:
            request.httpMethod = method.rawValue
            break
        case .post, .put:
            break
        case .del:
            break
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
                        
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(FailureType.self, from: data) as? Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
