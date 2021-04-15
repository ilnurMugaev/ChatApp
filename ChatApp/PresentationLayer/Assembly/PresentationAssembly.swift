//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 15.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol PresentationAssemblyProtocol {
    func conversationListViewController() -> ConversationListViewController
    func conversatioViewController() -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
}

class PresentationAssembly: PresentationAssemblyProtocol {
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationListViewController() -> ConversationListViewController {
        var model = conversationListModel()
        let conversationListVC = ConversationListViewController(presentationAssembly: self,
                                                                model: model)
        model.fetchDelegate = conversationListVC
        model.userInfoDelegate = conversationListVC
        return conversationListVC
    }
    
    private func conversationListModel() -> ConversationListModelProtocol {
        return ConversationListModel(themeService: serviceAssembly.themeService,
                                     saveToFileService: serviceAssembly.gcdFileService,
                                     channelsService: serviceAssembly.channelsService,
                                     fetchedResultsProvider: serviceAssembly.channelsFetchResultsProvider)
    }
    
    func conversatioViewController() -> ConversationViewController {
        var model = conversationModel()
        let conversationVC = ConversationViewController(model: model)
        
        model.fetchDelegate = conversationVC
        return conversationVC
    }
    
    private func conversationModel() -> ConversationModelProtocol {
        return ConversationModel(themeService: serviceAssembly.themeService,
                                 messageService: serviceAssembly.messagesService,
                                 fetchedResultsProvider: serviceAssembly.messagesFetchResultsProvider)
    }
    
    func profileViewController() -> ProfileViewController {
        var model = profileModel()
        let profileVC = ProfileViewController(model: model)
        model.userInfoDelegate = profileVC
        return profileVC
    }
    
    private func profileModel() -> ProfileModelProtocol {
        return ProfileModel(themeService: serviceAssembly.themeService,
                            gcdFileService: serviceAssembly.gcdFileService,
                            operationFileService: serviceAssembly.operationFileService)
    }
    
    func themesViewController() -> ThemesViewController {
        let model = themesModel()
        let themesVC = ThemesViewController(model: model)
        return themesVC
    }
    
    private func themesModel() -> ThemesModelProtocol {
        return ThemesModel(themeService: serviceAssembly.themeService)
    }
}
