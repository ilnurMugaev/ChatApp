//
//  ConversationViewModelFactory.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol ViewModelFactory {
    associatedtype Model
    associatedtype ViewModel
    
    static func createViewModel(with model: Model) -> ViewModel
}

struct ConversationViewModelFactory: ViewModelFactory {
    typealias Model = ChannelDB
    typealias ViewModel = ConversationCellModel
    
    static func createViewModel(with model: ChannelDB) -> ConversationCellModel {
        let name = model.name
        let message = model.lastMessage
        let date = model.lastActivity
        
        let conversationCellModel = ConversationCellModel(name: name, message: message, date: date)
        
        return conversationCellModel
    }
}
