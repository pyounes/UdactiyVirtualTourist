//
//  ImagesResponseModel.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/5/21.
//

import Foundation

struct ImagesResponseModel: Codable {
    let photos:     Photos!
    let stat:       String!
}

struct Photos: Codable {
    let page:       Int
    let pages:      Int
    let perpage:    Int
    let total:      String
    let photo:      [Photo]?
}

struct Photo: Codable {
    var id:         String
    var owner:      String
    var secret:     String
    var server:     String
    var farm:       Int
    var title:      String
    var ispublic:   Int
    var isfriend:   Int
    var isfamily:   Int
    var url_s:      URL
}



struct ImagesFailResponse: Codable {
    let stat: String
    let code: Int
    let message: String
}


// MARK: Equatable
extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}
