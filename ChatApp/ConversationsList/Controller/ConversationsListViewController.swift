//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 27.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

enum Sections: Int, CaseIterable {
    case online
    case history
}

class ConversationsListViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = String(describing: ConversationsListCell.self)
    private let cellNibName = String(describing: ConversationsListCell.self)
    
    private let conversationsListCellDataManager = ConversationsListCellDataManager()
    private var configuration: ConversationListCellModel!
    
    private var onlineConversations = [ConversationListCellModel]()
    private var historyConversations = [ConversationListCellModel]()
    
    private let estimatedRowHeight: CGFloat = 90
    private let headerHeight: CGFloat = 50
    private let onlineSectionName = "Online"
    private let historySectionName = "History"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        registerNibs()
        obtainData()
    }

    /// Setup TableView.
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = estimatedRowHeight
    }

    /// Register Nibs.
    private func registerNibs() {
        let cellNib = UINib(nibName: cellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    /// Obtain data.
    func obtainData() {
        let conversationData = conversationsListCellDataManager.obtainConversationsListCellData()
        onlineConversations = conversationData.filter({ $0.isOnline == true })
        historyConversations = conversationData.filter({ $0.isOnline == false && !($0.message?.isEmpty == true) })
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 1 }
        
        switch section {
        case .online:
            return onlineConversations.count
        case .history:
            return historyConversations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Sections(rawValue: indexPath.section) else { return ConversationsListCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListCell else { return UITableViewCell() }
        
        let model: ConversationListCellModel
        
        switch section {
        case .online:
            model = onlineConversations[indexPath.row]
        case .history:
            model = historyConversations[indexPath.row]
        }
        
        cell.configure(with: model)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Sections(rawValue: section) else { return nil }
        
        switch section {
        case .online:
            return onlineSectionName
        case .history:
            return historySectionName
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
}
