//
//  ConversationListModel.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 15.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol ConversationListModelProtocol: UserInfoProtocol, ThemesProtocol {
    var fetchDelegate: ChannelsFetchedResultsServiceDelegate? { get set }
    var dataProvider: ChannelsDataProviderProtocol { get }
    
    func makeFetchedResultsController()
    func getChannels()
    func addChannel(in vc: AlertPresentableProtocol, channelName: String)
}

class ConversationListModel: ConversationListModelProtocol, UserInfoProtocol {
    weak var fetchDelegate: ChannelsFetchedResultsServiceDelegate?
    weak var userInfoDelegate: UserInfoDelegate?
    
    private let themeService: ThemeServiceProtocol
    private let saveToFileService: SaveDataToFileServiceProtocol
    private let channelsService: ChannelsServiceProtocol
    private var fetchedResultsProvider: ChannelsFetchedResultsServiceProtocol
    var dataProvider: ChannelsDataProviderProtocol
    
    init(themeService: ThemeServiceProtocol,
         saveToFileService: SaveDataToFileServiceProtocol,
         channelsService: ChannelsServiceProtocol,
         fetchedResultsProvider: ChannelsFetchedResultsServiceProtocol) {
        self.themeService = themeService
        self.saveToFileService = saveToFileService
        self.channelsService = channelsService
        self.fetchedResultsProvider = fetchedResultsProvider
        
        self.dataProvider = ChannelsDataProvider(fetchedResultsProvider: self.fetchedResultsProvider, channelsService: self.channelsService, themeService: self.themeService)
    }
    
    func makeFetchedResultsController() {
        fetchedResultsProvider.delegate = fetchDelegate
        fetchedResultsProvider.makeFetchedResultsController()
    }
    
    func getChannels() {
        let currentChannels = fetchedResultsProvider.fetchedResultsController?.fetchedObjects ?? []
        channelsService.getChannels(currentChannels: currentChannels)
    }
    
    func addChannel(in vc: AlertPresentableProtocol, channelName: String) {
        channelsService.addChannel(in: vc, channelName: channelName)
    }
    
    func loadUserData(completion: @escaping() -> Void) {
        saveToFileService.loadData { (name, _, photo) in
            DispatchQueue.main.async {
                self.userInfoDelegate?.user.name = name ?? "No name"
                Constants.senderName = name ?? "No name"
                self.userInfoDelegate?.user.photo = photo
                
                completion()
            }
        }
    }
    
    func currentTheme() -> Theme {
        return themeService.currentTheme
    }
    
    func setTheme(theme: Theme) {
        themeService.applyTheme(theme: theme)
        themeService.updateWindows()
    }
}
