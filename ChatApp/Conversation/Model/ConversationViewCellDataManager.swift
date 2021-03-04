//
//  ConversationViewCellDataManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 04.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

class ConversationViewCellDataManager {
    
    func obtainConversationViewCellData() -> [ConversationViewCellModel] {
        let message1 = ConversationViewCellModel(text: "У тебя было яблоко, тебе дали еще одно.\nСколько у тебя яблок?", isIncomingMessage: false)
        let message2 = ConversationViewCellModel(text: "Одно яблоко.\nПотому что яблоко + одно = одно яблоко.", isIncomingMessage: true)
        let message3 = ConversationViewCellModel(text: "Твой родной язык джаваскрипт что ли? 😂😂😂", isIncomingMessage: false)
        let message4 = ConversationViewCellModel(text: "😁", isIncomingMessage: true)
        
        return [message1, message2, message3, message4]
    }
}
