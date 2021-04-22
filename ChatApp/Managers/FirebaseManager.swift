//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseManagerProtocol {
    func getChannels(completion: @escaping ([[String: Any]], [[String: Any]], [String]) -> Void)
    func addChannel(name: String, completion: @escaping (Error?) -> Void)
    func deleteChannel(channelId: String)
    func getMessages(with channelId: String, completion: @escaping([[String: Any]]) -> Void)
    func sendMessage(channelId: String, messageData: [String: Any], completion: @escaping (Error?) -> Void)
}

class FirebaseManager: FirebaseManagerProtocol {
    private let db = Firestore.firestore()
    
    func getChannels(completion: @escaping ([[String: Any]], [[String: Any]], [String]) -> Void) {
        let reference = db.collection("channels")
        
        reference.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            
            var addedChannels = [[String: Any]]()
            var modifiedChannels = [[String: Any]]()
            var removedChannels = [String]()
            
            snapshot.documentChanges.forEach { (diff) in
                if diff.type == .added {
                    let channelIdentifier = diff.document.documentID
                    let channelDict = diff.document.data()
                    addedChannels.append(["identifier": channelIdentifier, "dict": channelDict])
                    
                }
                if diff.type == .modified {
                    let channelIdentifier = diff.document.documentID
                    let channelDict = diff.document.data()
                    modifiedChannels.append(["identifier": channelIdentifier, "dict": channelDict])
                }
                if diff.type == .removed {
                    removedChannels.append(diff.document.documentID)
                }
            }
            
            DispatchQueue.main.async {
                completion(addedChannels, modifiedChannels, removedChannels)
            }
        }
    }
    
    func addChannel(name: String, completion: @escaping (Error?) -> Void) {
        let reference = db.collection("channels")
        
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            reference.addDocument(data: ["name": name]) {error in
                if let error = error {
                    print("Error adding channel")
                    DispatchQueue.main.async {
                        completion(error)
                    }
                } else {
                    print("Successfully added channel")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func deleteChannel(channelId: String) {
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            let messageReference = self.db.collection("channels").document(channelId).collection("messages")
            messageReference.getDocuments { (snapshot, _) in
                guard let snapshot = snapshot else { return }
                
                snapshot.documents.forEach { (message) in
                    messageReference.document(message.documentID).delete { (error) in
                    if let error = error {
                        print("Error deleting message: \(error)")
                    } else {
                        print("Successfully deleted message")
                    }
                    }
                }
            }
            
            let channelReference = self.db.collection("channels")
            channelReference.document(channelId).delete { (error) in
                if let error = error {
                    print("Error deleting channel: \(error)")
                } else {
                    print("Successfully deleted channel")
                }
            }
        }
    }
    
    func getMessages(with channelId: String, completion: @escaping([[String: Any]]) -> Void) {
        let reference = db.collection("channels").document(channelId).collection("messages")
        
        reference.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            var addedMessages = [[String: Any]]()

            snapshot.documentChanges.forEach { (diff) in
                if diff.type == .added {
                    let messageIdentifier = diff.document.documentID
                    let messageDict = diff.document.data()
                    addedMessages.append(["identifier": messageIdentifier, "dict": messageDict])
                }
            }
            
            DispatchQueue.main.async {
                completion(addedMessages)
            }
        }
    }
    
    func sendMessage(channelId: String, messageData: [String: Any], completion: @escaping (Error?) -> Void) {
        let reference = db.collection("channels").document(channelId).collection("messages")
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            reference.addDocument(data: messageData) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
