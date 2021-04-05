//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/5/21.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDesc, error) in
            guard error == nil else { fatalError(error!.localizedDescription)}
        }
        completion?()
    }
}
