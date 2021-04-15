//
//  ChannelsDataProvider.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol ChannelsDataProviderProtocol: UITableViewDelegate, UITableViewDataSource {
    var fetchedResultsProvider: ChannelsFetchedResultsServiceProtocol { get set }
}

class ChannelsDataProvider: NSObject, ChannelsDataProviderProtocol {
    var fetchedResultsProvider: ChannelsFetchedResultsServiceProtocol
    var channelsService: ChannelsServiceProtocol
    var themeService: ThemeServiceProtocol
    
    init(fetchedResultsProvider: ChannelsFetchedResultsServiceProtocol, channelsService: ChannelsServiceProtocol, themeService: ThemeServiceProtocol) {
        self.fetchedResultsProvider = fetchedResultsProvider
        self.channelsService = channelsService
        self.themeService = themeService
    }
}

extension ChannelsDataProvider: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsProvider.fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell") as? ConversationCell,
            let channels = fetchedResultsProvider.fetchedResultsController?.fetchedObjects else { return ConversationCell() }
        let model = ConversationViewModelFactory.createViewModel(with: channels[indexPath.row])

        cell.setUpAppearance(theme: themeService.currentTheme)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = fetchedResultsProvider.fetchedResultsController?.fetchedObjects?[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidSelectRow notification"), object: self, userInfo: ["channel": channel as Any])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let channel = fetchedResultsProvider.fetchedResultsController?.fetchedObjects?[indexPath.row] else { return }
            channelsService.deleteChannel(channelId: channel.identifier)
        }
    }
}
