//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 02.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "Chat", withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        return mom
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = dirURL?.appendingPathComponent("Chat.sqlite")
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType,
                                       configurationName: nil,
                                       at: fileURL, options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        
        return psc
    }()
    
    private lazy var writeToDBContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writeToDBContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                    try performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    private func performSave(in context: NSManagedObjectContext) throws {
        context.perform {
            print("Is main thread: ", Thread.isMainThread)
            do {
                try context.save()
                if let parent = context.parent {
                    try self.performSave(in: parent)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: mainContext)
    }
    
    @objc private func contextObjectsDidChange(notification: NSNotification) {

        guard let userInfo = notification.userInfo else {return}
        
        if let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("\nInserted objects: \(insertedObjects.count)\n")
            if let insertedChannels = insertedObjects as? Set<ChannelDB> {
                insertedChannels.forEach { (channel) in
                    print("***Channel name: ", channel.name)
                }
            } else if let insertedMessages = insertedObjects as? Set<MessageDB> {
                insertedMessages.forEach { (message) in
                    print("---Message content: ", message.content)
                }
            }
        }
        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            print("\nUpdated objects: \(updatedObjects.count)\n")
            if let updatedChannels = updatedObjects as? Set<ChannelDB> {
                updatedChannels.forEach { (channel) in
                    print("***Channel name: ", channel.name)
                }
            } else if let updatedMessages = updatedObjects as? Set<MessageDB> {
                updatedMessages.forEach { (message) in
                    print("---Message content: ", message.content)
                }
            }
        }
        if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            print("\nDeleted objects: \(deletedObjects.count)\n")
            if let deletedChannels = deletedObjects as? Set<ChannelDB> {
                deletedChannels.forEach { (channel) in
                    print("***Channel name: ", channel.name)
                }
            } else if let deletedMessages = deletedObjects as? Set<MessageDB> {
                deletedMessages.forEach { (message) in
                    print("---Message content: ", message.content)
                }
            }
        }
    }
    
    func printInitialStatistics() {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        mainContext.perform {
            do {
                let channels = try self.mainContext.fetch(request)
                print("\nDatabase contains \(channels.count) channels\n")
                channels.forEach { (channel) in
                    print("+++Channel details: \(channel.name)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
