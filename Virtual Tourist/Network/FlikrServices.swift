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
    func getImagesByLocation(lat: Double, lon: Double,completion: @escaping (ImagesResponseModel?, Error?) -> Void) {
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
    
    
    /**
     - EndPoint name:
     - Method               : Download Images
     - Parameters     :
     - Comment           : function to download images for from a specific URL
     - Object                : 
     */
    func downloadImage(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        TASKManager.downloadHandler(url: url) { (data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = data {
                    completion(data, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
}
