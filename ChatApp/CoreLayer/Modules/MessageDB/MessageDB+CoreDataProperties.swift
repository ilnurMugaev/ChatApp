//
//  MessageDB+CoreDataProperties.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 02.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation
import CoreData

extension MessageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var identifier: String
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDB?

    class func createMessage(context: NSManagedObjectContext, identifier: String?, dict: [String: Any]) -> MessageDB? {
        guard let identifier = identifier,
            let senderId = dict["senderId"] as? String,
            let senderName = dict["senderName"] as? String,
            let content = dict["content"] as? String,
            let created = HelperFunctions.makeDateFromTimestamp(dict["created"]) else {return nil}
        
        let messageDB = MessageDB(context: context)
        messageDB.identifier = identifier
        messageDB.senderId = senderId
        messageDB.senderName = senderName
        messageDB.content = content
        messageDB.created = created
        
        return messageDB
    }
}
