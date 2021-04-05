//
//  MapVC.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/4/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // Variables
    var annotations = [MKPointAnnotation]()
    
    let locations: [Location] = [Location(name: "Beirut", lat: 33.8938, lon: 35.5018, images: [Imagee(url: "https://asd.asd.com"),
                                                                                               Imagee(url: "https://asd1.asd.com"),
                                                                                               Imagee(url: "https://asd2.asd.com"),
                                                                                               Imagee(url: "https://asd3.asd.com")]),
                                 Location(name: "Jarjouh", lat: 33.444705, lon: 35.5199817, images: [Imagee(url: "https://asd.asd.com"),
                                                                                               Imagee(url: "https://asd1.asd.com"),
                                                                                               Imagee(url: "https://asd2.asd.com"),
                                                                                               Imagee(url: "https://asd3.asd.com")]),
                                 Location(name: "Anjar", lat: 33.7278717, lon: 35.9399621, images: [Imagee(url: "https://asd.asd.com"),
                                                                                               Imagee(url: "https://asd1.asd.com"),
                                                                                               Imagee(url: "https://asd2.asd.com"),
                                                                                               Imagee(url: "https://asd3.asd.com")]),
                                 Location(name: "Beirut", lat: 33.8938, lon: 35.5018, images: [Imagee(url: "https://asd.asd.com"),
                                                                                               Imagee(url: "https://asd1.asd.com"),
                                                                                               Imagee(url: "https://asd2.asd.com"),
                                                                                               Imagee(url: "https://asd3.asd.com")])]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        StudentServices.shared.getStudentLocations(completion: handleGetStudentLocationResponse(studentLocations:error:))
//
        
        
        
        mapView.delegate = self
        
        self.addPins(studentLocations: locations)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        StudentServices.shared.getStudentLocations(completion: handleGetStudentLocationResponse(studentLocations:error:))
    }
    

    // MARK: - Actions
//    private func handleGetStudentLocationResponse(studentLocations: [StudentLocation]?, error: Error?) {
//        if let error = error {
//            showAlert(message: error.localizedDescription, title: "Error")
//        } else {
//            if let locations = studentLocations {
//                GlobalData.shared.locations = locations
//
//            } else {
//                showAlert(message: "Did not find any Student Locations", title: "Attention")
//            }
//        }
//    }
    
    
    
    // Add Student Pins on Map
    func addPins(studentLocations: [Location]) {
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        for location in studentLocations {

            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.lat)
            let long = CLLocationDegrees(location.lon)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let mediaURL = location.images.first?.url

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.name)"
            annotation.subtitle = mediaURL

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
}



// MARK: MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
//            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            pinView!.isEnabled = true
//            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(mapView.annotations.count)
    }

}


