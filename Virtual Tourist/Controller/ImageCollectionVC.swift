//
//  ImageCollectionVC.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/5/21.
//

import UIKit
import MapKit
import CoreData


class ImageCollectionVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageColView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Variables
    var pin: Pin!
    var images: [Image] = []
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        // flowlayout spces
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.fetchImages()
        self.addPin(pin: pin)
        
    }
    
    
    // Custom Methods
    private func fetchImages() {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", self.pin)
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            images = result
            
            if images.count == 0 {
                
            } else {
                
            }
        }
    }
    
    // Add loaded Pins on the Map
    private func addPin(pin: Pin) {
        let coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }


}


//MARK: -  Collection View Delegates
extension ImageCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        return cell
    }
    
    
}

