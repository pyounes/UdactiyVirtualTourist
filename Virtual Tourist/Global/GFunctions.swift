//
//  GFunctions.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/5/21.
//

import Foundation
import MapKit

class Global {
    
    class func pinView(mapView: MKMapView, annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
