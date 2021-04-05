//
//  Temp+Location.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/5/21.
//

import Foundation

struct Location {
    var name: String
    var lat: Double
    var lon: Double
    var images: [Imagee]
}


struct Imagee {
    var url: String
}
