//
//  ChannelsFetchedResultsService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit
import CoreData

protocol ChannelsFetchedResultsServiceProtocol {
    var delegate: ChannelsFetchedResultsServiceDelegate? { get set }
    var fetchedResultsController: NSFetchedResultsController<ChannelDB>? { get }
    func makeFetchedResultsController()
}

protocol ChannelsFetchedResultsServiceDelegate: class {
    var tableView: UITableView! { get }
}

class ChannelsFetchedResultsService: NSObject, ChannelsFetchedResultsServiceProtocol {
    weak var delegate: ChannelsFetchedResultsServiceDelegate?
    let fetchManager: FetchManagerProtocol
    var fetchedResultsController: NSFetchedResultsController<ChannelDB>?
    
    init(fetchManager: FetchManagerProtocol) {
        self.fetchManager = fetchManager
    }
    
    func makeFetchedResultsController() {
        let sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        
        fetchedResultsController = fetchManager.makeFetchedResultsController(sortDescriptors: sortDescriptors, predicate: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Error performing fetch: \(error)")
        }
        
        fetchedResultsController?.delegate = self
    }
}

extension ChannelsFetchedResultsService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("begin update")
        delegate?.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("Inserted channel at line \(newIndexPath)", controller.managedObjectContext.description)
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.tableView.reloadRows(at: [indexPath], with: .automatic)
                print("Updated channel at line \(indexPath)")
            }
        case .delete:
            if let indexPath = indexPath {
                delegate?.tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Deleted channel at line \(indexPath)")
            }
        case .move:
            if let indexPath = indexPath,
                let newIndexPath = newIndexPath {
                delegate?.tableView.deleteRows(at: [indexPath], with: .automatic)
                delegate?.tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("Moved channel from line \(indexPath) to line \(newIndexPath)")
            }
        @unknown default:
            print("Unknown channel case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("end update")
        delegate?.tableView.endUpdates()
    }
}
