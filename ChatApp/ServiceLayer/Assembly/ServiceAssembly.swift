//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 15.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol ServiceAssemblyProtocol {
    var channelsService: ChannelsServiceProtocol { get }
    var channelsFetchResultsProvider: ChannelsFetchedResultsServiceProtocol { get }
    var messagesService: MessagesServiceProtocol { get }
    var messagesFetchResultsProvider: MessagesFetchedResultsServiceProtocol { get }
    var gcdFileService: SaveDataToFileServiceProtocol { get }
    var operationFileService: SaveDataToFileServiceProtocol { get }
    var themeService: ThemeServiceProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelsService: ChannelsServiceProtocol = ChannelsService(firebaseManager: self.coreAssembly.firebaseManager,
                                                                        coreDataManager: self.coreAssembly.coreDataManager)
    lazy var channelsFetchResultsProvider: ChannelsFetchedResultsServiceProtocol = ChannelsFetchedResultsService(fetchManager: self.coreAssembly.fetchManager)
    lazy var messagesService: MessagesServiceProtocol = MessagesService(firebaseManager: self.coreAssembly.firebaseManager,
                                                                        coreDataManager: self.coreAssembly.coreDataManager)
    lazy var messagesFetchResultsProvider: MessagesFetchedResultsServiceProtocol = MessagesFetchedResultsService(fetchManager: self.coreAssembly.fetchManager)
    lazy var gcdFileService: SaveDataToFileServiceProtocol = GCDFileService(saveToFileManager: self.coreAssembly.saveToFileManager)
    lazy var operationFileService: SaveDataToFileServiceProtocol = OperationFileService(saveToFileManager: self.coreAssembly.saveToFileManager)
    lazy var themeService: ThemeServiceProtocol = ThemeService(gcdFileService: GCDFileService(saveToFileManager: self.coreAssembly.saveToFileManager))
}
