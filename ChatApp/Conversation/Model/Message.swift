//
//  Message.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init? (identifier: String?, dict: [String: Any]) {
        guard let identifier = identifier,
            let senderId = dict["senderId"] as? String,
            let senderName = dict["senderName"] as? String,
            let content = dict["content"] as? String,
            let createdTimestamp = dict["created"] as? Timestamp else {return nil}
        
        self.identifier = identifier
        self.senderId = senderId
        self.senderName = senderName
        self.content = content
        self.created = createdTimestamp.dateValue()
    }
}
