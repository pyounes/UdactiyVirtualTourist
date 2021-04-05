//
//  MapVC.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/4/21.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // Variables
    var pins: [Pin] = []
    
    var dataController: DataController!
    
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
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
        mapView.delegate = self
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            pins = result
        }
        
        self.loadPins(pins: pins)
        
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
    
    //
    @objc func handleTap(gestureReconizer: UIGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizer.State.began {
            let tapLocation = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(tapLocation,toCoordinateFrom: mapView)

            let pin = Pin(context: dataController.viewContext)
            pin.lat = coordinate.latitude.magnitude
            pin.lon = coordinate.longitude.magnitude
            
            do {
                try dataController.viewContext.save()
                pins.append(pin)
                self.addPin(pin: pin)
            } catch {
                showAlert(message: "Error", title: "Your Data hasn't Been Save")
            }
        }
    }
    
    
    // Add Pins on Map
    func loadPins(pins: [Pin]) {
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        for pin in pins {

            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(pin.lat)
            let long = CLLocationDegrees(pin.lon)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    // Show Location On the map
    private func addPin(pin: Pin) {
        let coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        mapView.setRegion(region, animated: true)
    }
}



// MARK: MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
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


