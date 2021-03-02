//
//  ConversationsListCellDataManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 28.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationsListCellDataManager {
    
    private let defaultImage = UIImage(named: "default")!
    
    func obtainConversationsListCellData() -> [ConversationListCellModel] {
        
        let cell1 = ConversationListCellModel(name: "Ilon Mask",
                                              message: "Hello",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: true)
        
        let cell2 = ConversationListCellModel(name: "Олег",
                                              message: "Ильнур, привет! Добро пожаловать в нашу команду!",
                                              date: Date() - 1000,
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: true)
        
        let cell3 = ConversationListCellModel(name: "Дядя Вова",
                                              message: "Я позвоню ему...",
                                              date: Date() - 200_000,
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: false)
                
        let cell4 = ConversationListCellModel(name: "Алексей",
                                              message: "Ну как, долетел?",
                                              date: Date(timeIntervalSinceReferenceDate: 476900000),
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: true)
        
        let cell5 = ConversationListCellModel(name: "Димон",
                                              message: "Спишь?",
                                              date: Date() - 60_000,
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: false)
        
        let cell6 = ConversationListCellModel(name: "Юрий Дудь",
                                              message: "Будешь дуть? 🤣",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: false)
        
        let cell7 = ConversationListCellModel(name: "Саня",
                                              message: "Ты там что, с калькулятора сидишь?",
                                              date: Date() - 300_000,
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: false)
        
        let cell8 = ConversationListCellModel(name: "Колян",
                                              message: "Время 4 утра, ЧТО ТЕБЕ ОТ МЕНЯ НУЖНО?",
                                              date: Date() - 20_000,
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: false)
        
        let cell9 = ConversationListCellModel(name: "Жена",
                                              message: "Будешь жить как в сказке 😂😂😂",
                                              date: Date() - 5000,
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: true)
        
        let cell10 = ConversationListCellModel(name: "Ivan",
                                              message: "Твой родной язык это джаваскрипт что ли?",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: false)
        
        let cell11 = ConversationListCellModel(name: "Интернет магазин",
                                              message: "Мы можем переназначить Ваш заказ на другого курьера или же отменить заказ? Мы не смогли понять что он говорит",
                                              date: Date(timeIntervalSinceReferenceDate: 478500000),
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: false)
        
        let cell12 = ConversationListCellModel(name: "По объявлению",
                                              message: "И сырный соус",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: false)
        
        let cell13 = ConversationListCellModel(name: "Еврейка",
                                              message: "Шалом! Есть шикарное контрпредложение: давай ты мне фото без белья, и все сэкономят! М?)",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: false)
        
        let cell14 = ConversationListCellModel(name: "Iphone",
                                              message: "Конечно. Прямо сейчас могу привезти. Пишите адрес.",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: false)
        
        let cell15 = ConversationListCellModel(name: "Игорь",
                                              message: "горь",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: false)
        
        let cell16 = ConversationListCellModel(name: "Карл",
                                              message: "Пусть этим занимаются идеологи, а я просто спекулянт",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: false)
        
        let cell17 = ConversationListCellModel(name: "Алиса",
                                              message: "Попроси об этом Сири",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: false)
        
        let cell18 = ConversationListCellModel(name: "Гадалка",
                                              message: "Вот смотрите, я когда движок на холодную завожу, в момент, когда обороты падают ниже 1000, происходит их резкий подъем до 1500 примерно на секунду и потом падают до 900, дальше все нормально, можете узнать из за чего это? Ошибок никаких нет",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: true)
        
        let cell19 = ConversationListCellModel(name: "Вася",
                                              message: "Иногда я думаю: как мы до сих пор дружим?",
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: true,
                                              hasUnreadMessages: true)
        
        let cell20 = ConversationListCellModel(name: "Алексей",
                                              message: nil,
                                              date: Date(),
                                              avatar: defaultImage,
                                              isOnline: false,
                                              hasUnreadMessages: false)
        
        return [cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10,
                cell11, cell12, cell13, cell14, cell15, cell16, cell17, cell18, cell19, cell20]
    }
}
