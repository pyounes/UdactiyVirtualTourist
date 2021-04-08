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
    @IBOutlet weak var btnNewCollection: UIButton!
    
    // Variables
    var pin: Pin!
    var photos: [Photo] = []
    var images: [Image] = []
    var dataController: DataController!
    
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
        
        self.btnNewCollection.isEnabled = false
        
        self.fetchImages(pin: self.pin, page: 1)
        self.addPin(pin: pin)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    // MARK: - Custom Methods
    fileprivate func fetchImages(pin: Pin, page: Int) {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            images = result
            self.imageColView.reloadData()
        }
    }
//    private func fetchImages(pin: Pin, page: Int) {
//
//        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultsController.delegate = self
//
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            fatalError("The fetch could not be performed: \(error.localizedDescription)")
//        }
//
//        if fetchedResultsController.sections?[0].numberOfObjects == 0 {
//            self.getImages(pin: self.pin, page: page)
//        } else {
//            self.btnNewCollection.isEnabled = true
//        }
//    }
    

    
    // get images
    private func getImages(pin: Pin, page: Int) {
        self.btnNewCollection.isEnabled = false
        FlikrServices.shared.getImagesByLocation(lat: pin.lat, lon: pin.lon, page: page) { (result, error) in
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
            FlikrServices.shared.downloadImage(url: photo.url_s) {(data, error) in
                guard let data = data, error == nil else {return}
                self.addImage(pin: self.pin, imageData: data)
                if photo == photos.last {
                    self.btnNewCollection.isEnabled = true
                }
            }
        }
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
    
//    private func deleteImages(pin: Pin) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
//        let predicate = NSPredicate(format: "pin == %@", pin)
//        fetchRequest.predicate = predicate
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        batchDeleteRequest.resultType = .resultTypeCount
//
//        do {
//            try dataController.viewContext.execute(batchDeleteRequest)
//            dataController.viewContext.reset()
//            try self.fetchedResultsController.performFetch()
////            self.imageColView.reloadData()
//        } catch {
//            fatalError("The fetch could not be performed: \(error.localizedDescription)")
//        }
//        self.fetchImages(pin: pin, page: 20)
//
//
//
//    }
    
    private func deleteImage(indexPath: IndexPath) {
        let image = images[indexPath.row]
        self.imageColView.deleteItems(at: [indexPath])
        dataController.viewContext.delete(image)
        try? dataController.viewContext.save()
        self.fetchImages(pin: self.pin, page: 1)
    }

    // MARK: - IBActions
    @IBAction func btnNewCollectionClicked(_ sender: UIButton) {
//        deleteImages(pin: self.pin)
//        self.imageColView.reloadData()
        
    }
    
}


// MARK: -  Collection View Delegates
extension ImageCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.setupCell(image: images[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.deleteImage(indexPath: indexPath)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
//extension ImageCollectionVC: NSFetchedResultsControllerDelegate {
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            self.imageColView.insertItems(at: [newIndexPath!])
//            break
//        case .delete:
//            self.imageColView.deleteItems(at: [indexPath!])
//            break
//        case .update:
//            break
//        default:
//            break
//        }
//    }
//}


// MARK: MKMapViewDelegate
extension ImageCollectionVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        Global.pinView(mapView: mapView, annotation: annotation)
    }
}
