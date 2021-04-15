//
//  MessagesDataProvider.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol MessagesDataProviderProtocol: UITableViewDelegate, UITableViewDataSource {
    var fetchedResultsProvider: MessagesFetchedResultsServiceProtocol { get set }
}

class MessagesDataProvider: NSObject, MessagesDataProviderProtocol {
    var fetchedResultsProvider: MessagesFetchedResultsServiceProtocol
    var themeService: ThemeServiceProtocol
    
    init(fetchedResultsProvider: MessagesFetchedResultsServiceProtocol, themeService: ThemeServiceProtocol) {
        self.fetchedResultsProvider = fetchedResultsProvider
        self.themeService = themeService
    }
}

extension MessagesDataProvider: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = fetchedResultsProvider.fetchedResultsController?.fetchedObjects ?? []
        if array.isEmpty {
            tableView.backgroundView?.isHidden = false
            return 0
        } else {
            tableView.backgroundView?.isHidden = true
            return fetchedResultsProvider.fetchedResultsController?.fetchedObjects?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messages = fetchedResultsProvider.fetchedResultsController?.fetchedObjects else { return UITableViewCell() }
        let message = messages[indexPath.row]
        let model = MessageViewModelFactory.createViewModel(with: message)
        
        if message.senderId == Constants.senderId {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sentMessageCell") as? SentMessageCell else { return SentMessageCell() }
            cell.setUpAppearance(theme: themeService.currentTheme)
            cell.configure(with: model)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell") as? ReceivedMessageCell else { return ReceivedMessageCell() }
            cell.setUpAppearance(theme: themeService.currentTheme)
            cell.configure(with: model)
            return cell
        }
    }
}
