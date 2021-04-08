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
    var photos: [Photo] = []
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Image>!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Pin Image Collection"
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        // flowlayout spces
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.fetchImages(pin: self.pin)
        self.addPin(pin: pin)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    
    // MARK: - Custom Methods
    private func fetchImages(pin: Pin) {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin)-Images")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        if fetchedResultsController.sections?[0].numberOfObjects == 0 {
            self.getImages(pin: self.pin)
        }
        
        try? dataController.viewContext.save()
        
        DispatchQueue.main.async {
            self.imageColView.reloadData()
        }
    }
    
    // get images
    private func getImages(pin: Pin) {
        FlikrServices.shared.getImagesByLocation(lat: pin.lat, lon: pin.lon) { (result, error) in
            guard let photos = result?.photos.photo else {
                self.showAlert(message: error!.localizedDescription, title: "Error")
                return
            }
            self.downloadImages(photos: photos)
        }
    }
    
    // Download Images
    private func downloadImages(photos: [Photo]) {
        photos.forEach { (photo) in
            FlikrServices.shared.downloadImage(url: photo.url_s) { (data, error) in
                guard let data = data, error == nil else {return}
                self.addImage(pin: self.pin, imageData: data)
            }
        }
        
        
        
//        DispatchQueue.global().async { [weak self] in
//            guard let strong = self else {return }
//            if let data = try? Data(contentsOf: strong.photos.first!.url_s) {
//
//
//            }
//        }
    }
    
    // add Image to CoreData
    private func addImage(pin: Pin, imageData: Data) {
        let image = Image(context: self.dataController.viewContext)
        image.creationDate = Date()
        image.pin = pin
        image.image = imageData
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


// MARK: -  Collection View Delegates
extension ImageCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.setupCell(image: fetchedResultsController.object(at: indexPath).image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = fetchedResultsController.object(at: indexPath)
        fetchedResultsController.managedObjectContext.delete(image)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension ImageCollectionVC: NSFetchedResultsControllerDelegate {


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.imageColView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            self.imageColView.deleteItems(at: [indexPath!])
            break
        case .update:
            break
        default:
            break
        }
    }
}


// MARK: MKMapViewDelegate
extension ImageCollectionVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        Global.pinView(mapView: mapView, annotation: annotation)
    }
}
