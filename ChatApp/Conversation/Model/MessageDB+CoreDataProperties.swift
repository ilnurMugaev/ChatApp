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
}
