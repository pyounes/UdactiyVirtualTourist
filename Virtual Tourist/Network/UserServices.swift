//
//  UserServices.swift
//  On The Map
//
//  Created by Pierre Younes on 3/9/21.
//

import Foundation

class UserServices {
    static let shared: UserServices = UserServices()
    
    
    /**
     - EndPoint name: session
     - Method               : POST
     - Parameters     :
     - Comment           : function to return the session
     - Object                : UserLogin
     */
    func login(logins body: Udacity, completion: @escaping (Bool, Error?) -> Void) {
        TASKManager.taskHandler(url: EndPoints.user(.login).url
                                ,method: .post
                                ,host: .udacity
                                ,responseType: UserLogin.self
                                ,body: body
                                ,failure: UdacityFailure.self) { (response, error) in
            if let error = error {
                completion(false, error)
            } else {
                if let response = response {
                    GlobalData.shared.sessionID = response.session.id
                    GlobalData.shared.uniqueKey = response.account.key
                    completion(true, nil)
                    
                } else {
                    completion(false, error)
                }
            }
        }
    }
    
    
    /**
     - EndPoint name: session
     - Method               : DELETE
     - Parameters     :
     - Comment           : function to return the session
     - Object                : UserLogin
     */
    func logout(completion: @escaping (Bool, Error?) -> Void) {
        let body = StudentServices.Dummy()
        TASKManager.taskHandler(url: EndPoints.user(.logout).url
                                ,method: .del
                                ,host: .udacity
                                ,responseType: UserLogin.self
                                ,body: body
                                ,failure: UdacityFailure.self) { (response, error) in
            if error == nil {
                GlobalData.shared.logOut()
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    /**
     - EndPoint name: session
     - Method               : GET
     - Parameters     : user_id
     - Comment           : function to return Public User Data
     - Object                : UserLogin
     */
    func getUserData(userId: String, completion: @escaping (UserResponse?, Error?) -> Void) {
        let body = StudentServices.Dummy()
        TASKManager.taskHandler(url: EndPoints.user(.getUserData(userId)).url
                                ,method: .get
                                ,host: .udacity
                                ,responseType: UserResponse.self
                                ,body: body
                                ,failure: UdacityFailure.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
