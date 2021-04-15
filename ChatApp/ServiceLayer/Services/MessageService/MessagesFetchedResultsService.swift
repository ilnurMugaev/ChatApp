//
//  MessagesFetchedResultsService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit
import CoreData

protocol MessagesFetchedResultsServiceProtocol {
    var delegate: MessagesFetchedResultsServiceDelegate? { get set }
    var fetchedResultsController: NSFetchedResultsController<MessageDB>? { get }
    func makeFetchedResultsController(channelIdentifier: String?)
}

protocol MessagesFetchedResultsServiceDelegate: class {
    var conversationView: ConversationView! { get }
}

class MessagesFetchedResultsService: NSObject, MessagesFetchedResultsServiceProtocol {
    weak var delegate: MessagesFetchedResultsServiceDelegate?
    let fetchManager: FetchManagerProtocol
    var fetchedResultsController: NSFetchedResultsController<MessageDB>?
    
    init(fetchManager: FetchManagerProtocol) {
        self.fetchManager = fetchManager
    }
    
    func makeFetchedResultsController(channelIdentifier: String?) {
        let sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        var predicate: NSPredicate?
        
        if let identifier = channelIdentifier {
            predicate = NSPredicate(format: "channel.identifier = %@", identifier)
        }
        
        fetchedResultsController = fetchManager.makeFetchedResultsController(sortDescriptors: sortDescriptors, predicate: predicate)
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Error performing fetch: \(error)")
        }
        
        fetchedResultsController?.delegate = self
    }
}

extension MessagesFetchedResultsService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("begin update")
        delegate?.conversationView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.conversationView.tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("Inserted message at line \(newIndexPath)")
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.conversationView.tableView.reloadRows(at: [indexPath], with: .automatic)
                print("Updated message at line \(indexPath)")
            }
        case .delete:
            if let indexPath = indexPath {
                delegate?.conversationView.tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Deleted message at line \(indexPath)")
            }
        default:
            print("Unknown message case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("end update")
        delegate?.conversationView.tableView.endUpdates()
    }
}
