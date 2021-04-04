//
//  TASKManager.swift
//  On The Map
//
//  Created by Pierre Younes on 3/8/21.
//

import Foundation

class TASKManager {
    
    enum Method: String {
        case post = "POST"
        case put  = "PUT"
        case get  = "GET"
        case del  = "DELETE"
    }
    
    enum Host {
        case udacity
        case parse
    }
    
    class func taskHandler<RequestType: Encodable, ResponseType: Decodable, FailureType: Decodable>(
        url: URL
        ,method: Method
        ,host: Host
        ,responseType: ResponseType.Type
        ,body: RequestType
        ,failure: FailureType.Type
        ,completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)

        switch method {
        case .get:
            break
        case .post, .put:
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if host == .udacity { request.addValue("application/json", forHTTPHeaderField: "Accept") }
            request.httpBody = try! JSONEncoder().encode(body)
            break
        case .del:
            request.httpMethod = method.rawValue
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
              if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
              request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            break
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if host == .udacity { data = data.subdata(in: 5..<data.count) }
            
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
