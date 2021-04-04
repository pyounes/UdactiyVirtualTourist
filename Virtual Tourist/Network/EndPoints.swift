//
//  EndPoints.swift
//  On The Map
//
//  Created by Pierre Younes on 3/8/21.
//

import Foundation


enum EndPoints {
    static let baseURL = "https://www.flickr.com"
    static let apiKey = "6d126c09fbcbf80966c3764fca7b592e"
    
    case getImagesByLocation(Double, Double)
    
    var string: String {
        switch self {
        case .getImagesByLocation(let lat, let lon):
            return "/services/rest/?method=flickr.photos.search&api_key=\(EndPoints.apiKey)&lat=\(lat)&lon=\(lon)&radius=20&per_page=5&format=json"
        }
    }
    
    // Returns the String Url and convert it to URL
    var url: URL {
        return URL(string: "\(EndPoints.baseURL)\(string)")!
    }
}