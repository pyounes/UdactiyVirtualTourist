//
//  FlikrServices.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/4/21.
//

import Foundation

class FlikrServices {
    static let shared: FlikrServices = FlikrServices()
    
    
    /**
     - EndPoint name: session
     - Method               : GET
     - Parameters     :
     - Comment           : function to return the session
     - Object                : UserLogin
     */
//    func getImagesByLocation(lat: Double, lon: Double, completion: @escaping (Bool, Error?) -> Void) {
//        TASKManager.taskHandler(url: EndPoints.getImagesByLocation(lat, lon)
//                                ,method: .get
//                                ,responseType: UserLogin.self
//                                ,failure: UdacityFailure.self) { (response, error) in
//            if let error = error {
//                completion(false, error)
//            } else {
//                if let response = response {
//                    GlobalData.shared.sessionID = response.session.id
//                    GlobalData.shared.uniqueKey = response.account.key
//                    completion(true, nil)
//
//                } else {
//                    completion(false, error)
//                }
//            }
//        }
//    }
//    
//    
//    /**
//     - EndPoint name: session
//     - Method               : DELETE
//     - Parameters     :
//     - Comment           : function to return the session
//     - Object                : UserLogin
//     */
//    func logout(completion: @escaping (Bool, Error?) -> Void) {
//        let body = StudentServices.Dummy()
//        TASKManager.taskHandler(url: EndPoints.user(.logout).url
//                                ,method: .del
//                                ,host: .udacity
//                                ,responseType: UserLogin.self
//                                ,body: body
//                                ,failure: UdacityFailure.self) { (response, error) in
//            if error == nil {
//                GlobalData.shared.logOut()
//                completion(true, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//    
//    
//    /**
//     - EndPoint name: session
//     - Method               : GET
//     - Parameters     : user_id
//     - Comment           : function to return Public User Data
//     - Object                : UserLogin
//     */
//    func getUserData(userId: String, completion: @escaping (UserResponse?, Error?) -> Void) {
//        let body = StudentServices.Dummy()
//        TASKManager.taskHandler(url: EndPoints.user(.getUserData(userId)).url
//                                ,method: .get
//                                ,host: .udacity
//                                ,responseType: UserResponse.self
//                                ,body: body
//                                ,failure: UdacityFailure.self) { (response, error) in
//            if let response = response {
//                completion(response, nil)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
}
