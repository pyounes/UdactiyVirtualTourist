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
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Image>!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Pin Image Collection"
        self.btnNewCollection.isEnabled = false
        
        setFlowLayout()
        
        
        self.addPin(pin: pin)
        
        self.fetchImages(pin: self.pin)
        self.downloadImages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    
    // MARK: - Custom Methods
    // function to set the Collection view flow layout
    private func setFlowLayout() {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        // flowlayout spces
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    

    
    // fetch images for a specific pin
    private func fetchImages(pin: Pin) {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            self.btnNewCollection.isEnabled = true
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    
    // Download Images
    private func downloadImage(image: Image) {
        if image.image == nil {
            self.btnNewCollection.isEnabled = false
            FlikrServices.shared.downloadImage(url: image.url!) { (data, error) in
                guard let data = data, error == nil else {return}
                self.editImage(image: image, imageData: data)
            }
        }
    }
    
    private func downloadImages() {
        if let images = fetchedResultsController.fetchedObjects {
            images.forEach { (image) in
                if image.image == nil {
                    self.btnNewCollection.isEnabled = false
                    FlikrServices.shared.downloadImage(url: image.url!) { (data, error) in
                        guard let data = data, error == nil else {return}
                        self.editImage(image: image, imageData: data)
                        
                        if image == images.last {
                            self.btnNewCollection.isEnabled = true
                        }
                    }
                }
            }
        }
    }
    
    // Get Images for this pin
    private func getImages(pin: Pin) {
        FlikrServices.shared.getImagesByLocation(lat: pin.lat, lon: pin.lon) { (result, error) in
            guard let images = result?.photos.photo else {
                self.showAlert(message: error!.localizedDescription, title: "Error")
                return
            }
                        
            self.editImageUrl(photos: images)
            self.downloadImages()

        }
    }
    
    // Edit Image to add the image raw data downloaded
    func editImageUrl(photos: [Photo]) {
        let context = self.dataController.viewContext
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        
        if let images = fetchedResultsController.fetchedObjects {
            
            for (photo, image) in zip(photos, images) {
                fetchRequest.predicate = NSPredicate(format: "uuid == %@ AND url != nil", image.uuid! as CVarArg)
                
                do {
                    let result = try context.fetch(fetchRequest)
                    if (result.count > 0) {
                        let managedObject = result[0] as NSManagedObject
                        managedObject.setValue(photo.url_s, forKey: "url")
                        managedObject.setValue(nil, forKey: "image")
                        try context.save()
                        print("Changes saved...")
                    }
                } catch {
                    print("Failed")
                }
                
            }
        }
    }
    
    // Edit Image to add the image raw data downloaded
    func editImage(image: Image, imageData: Data) {
        let uuid = image.uuid!
        let context = self.dataController.viewContext
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@ AND image == nil", uuid as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                let managedObject = result[0] as NSManagedObject
                managedObject.setValue(imageData, forKey: "image")
                try context.save()
                print("Changes saved...")
            }
        } catch {
            print("Failed")
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
    
    // add Image to CoreData
    private func addImage(pin: Pin, url: URL) {
        let image = Image(context: self.dataController.viewContext)
        image.uuid = UUID()
        image.creationDate = Date()
        image.pin = pin
        image.url = url
    }
    
    
    // Delete all Images
//    fileprivate func deleteAllImages() {
//        if let images = fetchedResultsController.fetchedObjects {
//            images.forEach { (image) in
//                dataController.viewContext.delete(image)
//            }
//
//            do {
//                try dataController.viewContext.save()
//            } catch {
//                print("Error When deleting Images")
//            }
//        }
//    }
//
//    // Delete all Images
//    fileprivate func batchDeleteAllImages() {
//        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
//        let predicate = NSPredicate(format: "pin == %@", pin)
//        fetchRequest.predicate = predicate
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
//
//        do {
//            try dataController.viewContext.execute(batchDeleteRequest)
//        } catch {
//
//        }
//    }
    
    
    
    // MARK: IBAction
    @IBAction func BtnNewCollectionClicked(_ sender: UIButton) {
        self.btnNewCollection.isEnabled = false
//        self.batchDeleteAllImages()
//        self.fetchImages(pin: self.pin)
//        self.imageColView.reloadData()
//        self.getImages(pin: self.pin)
//        self.fetchImages(pin: self.pin)
//        self.downloadImages()
        self.getImages(pin: self.pin)
        
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
//        self.downloadImage(image: fetchedResultsController.object(at: indexPath))
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
            self.imageColView.reloadItems(at: [indexPath!])
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
