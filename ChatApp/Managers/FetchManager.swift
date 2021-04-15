//
//  FetchManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation
import CoreData

protocol FetchManagerProtocol {
    func makeFetchedResultsController<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?,
                                                          predicate: NSPredicate?) -> NSFetchedResultsController<T>?
}

class FetchManager: FetchManagerProtocol {
    let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func makeFetchedResultsController<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?,
                                                          predicate: NSPredicate?) -> NSFetchedResultsController<T>? {
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else { return NSFetchedResultsController() }
        
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.resultType = .managedObjectResultType

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: coreDataManager.mainContext,
                                                                  sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }
}
