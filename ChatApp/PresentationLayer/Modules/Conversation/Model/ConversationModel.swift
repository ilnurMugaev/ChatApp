//
//  ConversationModel.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 15.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol ConversationModelProtocol {
    var fetchDelegate: MessagesFetchedResultsServiceDelegate? { get set }
    var dataProvider: MessagesDataProviderProtocol { get }
    
    func makeFetchedResultsController(channelIdentifier: String?)
    func getMessages(channelId: String?)
    func sendMessage(in vc: AlertPresentableProtocol, channelId: String, text: String)
    func currentTheme() -> Theme
}

class ConversationModel: ConversationModelProtocol {
    weak var fetchDelegate: MessagesFetchedResultsServiceDelegate?
    
    private let themeService: ThemeServiceProtocol
    private let messagesService: MessagesServiceProtocol
    private var fetchedResultsProvider: MessagesFetchedResultsServiceProtocol
    var dataProvider: MessagesDataProviderProtocol
    
    init(themeService: ThemeServiceProtocol,
         messageService: MessagesServiceProtocol,
         fetchedResultsProvider: MessagesFetchedResultsServiceProtocol) {
        self.themeService = themeService
        self.messagesService = messageService
        self.fetchedResultsProvider = fetchedResultsProvider
        self.dataProvider = MessagesDataProvider(fetchedResultsProvider: self.fetchedResultsProvider, themeService: self.themeService)
    }
    
    func makeFetchedResultsController(channelIdentifier: String?) {
        fetchedResultsProvider.delegate = fetchDelegate
        fetchedResultsProvider.makeFetchedResultsController(channelIdentifier: channelIdentifier)
    }
    
    func getMessages(channelId: String?) {
        if let channelId = channelId {
            messagesService.getMessages(channelId: channelId)
        }
    }
    
    func sendMessage(in vc: AlertPresentableProtocol, channelId: String, text: String) {
        messagesService.sendMessage(in: vc, channelId: channelId, text: text)
    }
    
    func currentTheme() -> Theme {
        return themeService.currentTheme
    }
}
