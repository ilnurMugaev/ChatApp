//
//  ChannelsService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ChannelsServiceProtocol {
    func getChannels(currentChannels: [ChannelDB])
    func addChannel(in vc: AlertPresentableProtocol, channelName: String)
    func deleteChannel(channelId: String)
}

class ChannelsService: ChannelsServiceProtocol {
    let firebaseManager: FirebaseManagerProtocol
    let coreDataManager: CoreDataManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.firebaseManager = firebaseManager
        self.coreDataManager = coreDataManager
    }

    func getChannels(currentChannels: [ChannelDB]) {
        firebaseManager.getChannels { (addedChannels, modifiedChannels, removedChannelsIDs) in
            self.coreDataManager.performSave { (context) in
                for channel in addedChannels {
                    if currentChannels.contains(where: { $0.identifier == channel["identifier"] as? String}) {
                        continue
                    } else {
                        let identifier = channel["identifier"] as? String
                        let dict = (channel["dict"] as? [String: Any]) ?? [ : ]
                        ChannelDB.createChannel(context: context, identifier: identifier, dict: dict)
                    }
                    
                }

                for channel in modifiedChannels {
                    guard let identifier = channel["identifier"] as? String else { continue }
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", identifier)
                    
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB,
                            let dict = channel["dict"] as? [String: Any] {
                            channelDB.modify(dict: dict)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }

                for channelId in removedChannelsIDs {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channelId)
                    
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            context.delete(channelDB)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addChannel(in vc: AlertPresentableProtocol, channelName: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        if !channelName.isEmpty,
        !(channelName.replacingOccurrences(of: " ", with: "") == "") {
            
            firebaseManager.addChannel(name: channelName) { (error) in
                if error != nil {
                    vc.showAlert(title: "Error", message: "Failed to create channel", preferredStyle: .alert, actions: [okAction], completion: nil)
                }
            }
        } else {
            vc.showAlert(title: "Error", message: "Please enter channel name", preferredStyle: .alert, actions: [okAction], completion: nil)
        }
    }
    
    func deleteChannel(channelId: String) {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", channelId)
        
        coreDataManager.performSave { (context) in
            do {
                let channelDB = try context.fetch(request).first
                if let channelDB = channelDB {
                    context.delete(channelDB)
                    firebaseManager.deleteChannel(channelId: channelDB.identifier)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
