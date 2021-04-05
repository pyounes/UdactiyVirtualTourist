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
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tap a Pin Or add a new One"
        self.loadMapLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTapOnMap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        mapView.delegate = self
        
        fetchPins()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    // MARK: - Actions
    // fetch Pins from Coredata
    fileprivate func fetchPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            pins = result
            self.loadPins(pins: pins)
        }
    }
    
    
    
    // handle Long Tap On Map
    @objc func handleTapOnMap(gestureReconizer: UIGestureRecognizer) {
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
    
    // Add loaded Pins on the Map
    private func addPin(pin: Pin) {
        let coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        mapView.setRegion(region, animated: true)
    }
    
    // get Pin from coreData to be sent to the ImageCollectionVC
    private func fetchSelectedPin(annotation: MKAnnotation) -> Pin {
        var pin: Pin = Pin(context: dataController.viewContext)
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "lat == %@ AND lon == %@", argumentArray: [annotation.coordinate.latitude, annotation.coordinate.longitude])
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                pin = result.first!
            }
        }
        return pin
    }
    
    // Get The Current Map View Position and Zoom
    private func saveMapLocation() {
        let mapRegion = [
            "latitude" : mapView.region.center.latitude,
            "longitude" : mapView.region.center.longitude,
            "latitudeDelta" : mapView.region.span.latitudeDelta,
            "longitudeDelta" : mapView.region.span.longitudeDelta
        ]
        UserDefaults.standard.set(mapRegion, forKey: "MapLocation")
    }
    
    // Load Previously saved MapLocation
    private func loadMapLocation() {
        if let mapRegin = UserDefaults.standard.dictionary(forKey: "MapLocation") {
            let location = mapRegin as! [String: Double]
            let center = CLLocationCoordinate2D(latitude: location["latitude"]!, longitude: location["longitude"]!)
            let span = MKCoordinateSpan(latitudeDelta: location["latitudeDelta"]!, longitudeDelta: location["longitudeDelta"]!)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}



// MARK: MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        Global.pinView(mapView: mapView, annotation: annotation)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = self.fetchSelectedPin(annotation: view.annotation!)
        self.pushImageCollectionVC(pin: pin, dataController: self.dataController)
    }
    
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.saveMapLocation()
    }

}
