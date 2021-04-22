//
//  ChannelDB+CoreDataProperties.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 02.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation
import CoreData

extension ChannelDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelDB> {
        return NSFetchRequest<ChannelDB>(entityName: "ChannelDB")
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messages: NSSet?
    
    class func createChannel(context: NSManagedObjectContext, identifier: String?, dict: [String: Any]) {
        guard let identifier = identifier,
            let name = dict["name"] as? String else { return }
        
        let channelDB = ChannelDB(context: context)
        channelDB.identifier = identifier
        channelDB.name = name
        channelDB.lastMessage = (dict["lastMessage"] as? String) ?? nil
        channelDB.lastActivity = HelperFunctions.makeDateFromTimestamp(dict["lastActivity"])
    }
    
    func modify(dict: [String: Any]) {
        guard let name = dict["name"] as? String else { return }
        
        self.name = name
        self.lastMessage = (dict["lastMessage"] as? String) ?? nil
        self.lastActivity = HelperFunctions.makeDateFromTimestamp(dict["lastActivity"])
    }
}

// MARK: Generated accessors for messages
extension ChannelDB {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageDB)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageDB)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
}
