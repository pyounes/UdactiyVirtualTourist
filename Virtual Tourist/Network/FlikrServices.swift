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
     - EndPoint name:
     - Method               : GET
     - Parameters     :
     - Comment           : function to return the images for a specific Location
     - Object                : ImagesResponseModel
     */
    func getImagesByLocation(lat: Double, lon: Double, completion: @escaping (ImagesResponseModel?, Error?) -> Void) {
        TASKManager.taskHandler(url: EndPoints.getImagesByLocation(lat, lon).url
                                ,responseType: ImagesResponseModel.self
                                ,failure: ImagesFailResponse.self) { (response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let response = response {
                    completion(response, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
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
