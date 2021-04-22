//
//  HelperFunctions.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation
import FirebaseFirestore

class HelperFunctions {
    static func makeDateFromTimestamp(_ timestamp: Any?) -> Date? {
        return (timestamp as? Timestamp)?.dateValue()
    }
    
    static func makeTimestampFromDate(_ date: Date) -> Timestamp {
        return Timestamp(date: date)
    }
}
