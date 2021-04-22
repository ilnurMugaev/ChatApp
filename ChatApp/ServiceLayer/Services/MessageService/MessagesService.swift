//
//  MessagesService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit
import CoreData

protocol MessagesServiceProtocol {
    func getMessages(channelId: String)
    func sendMessage(in vc: AlertPresentableProtocol, channelId: String, text: String)
}

class MessagesService: MessagesServiceProtocol {
    let firebaseManager: FirebaseManagerProtocol
    let coreDataManager: CoreDataManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.firebaseManager = firebaseManager
        self.coreDataManager = coreDataManager
    }
    
    func getMessages(channelId: String) {
        firebaseManager.getMessages(with: channelId) { (addedMessages) in
            self.coreDataManager.performSave { (context) in
                let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                request.predicate = NSPredicate(format: "identifier = %@", channelId)
                do {
                    let channelDB = try context.fetch(request).first
                    if let channelDB = channelDB {
                        let messagesDB = (channelDB.messages?.allObjects as? [MessageDB]) ?? [MessageDB]()
                        for message in addedMessages {
                            if messagesDB.contains(where: { $0.identifier == message["identifier"] as? String }) {
                                continue
                            } else {
                                let identifier = message["identifier"] as? String
                                let dict = (message["dict"] as? [String: Any]) ?? [ : ]
                                if let messageDB = MessageDB.createMessage(context: context, identifier: identifier, dict: dict) {
                                    channelDB.addToMessages(messageDB)
                                }
                            }
                        }
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func sendMessage(in vc: AlertPresentableProtocol, channelId: String, text: String) {
        let messageData = ["content": text,
                           "created": HelperFunctions.makeTimestampFromDate(Date()),
                           "senderId": Constants.senderId,
                           "senderName": Constants.senderName] as [String: Any]
        
        firebaseManager.sendMessage(channelId: channelId, messageData: messageData) { (error) in
            if error != nil {
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                vc.showAlert(title: "Error", message: "Failed to send message", preferredStyle: .alert, actions: [okAction], completion: nil)
            }
        }
    }
}
