//
//  MessageViewModelFactory.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

struct MessageViewModelFactory: ViewModelFactory {
    typealias Model = MessageDB
    typealias ViewModel = MessageCellModel
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    static func createViewModel(with model: MessageDB) -> MessageCellModel {
        let dateString = dateFormatter.string(from: model.created)
        return MessageCellModel(senderName: model.senderName, content: model.content, created: dateString)
    }
}
