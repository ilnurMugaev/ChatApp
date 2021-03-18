//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 03.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var conversationName: String?
    
    private let cellIdentifier = String(describing: ConversationViewCell.self)
    private let cellNibName = String(describing: ConversationViewCell.self)
    
    private let estimatedRowHeight: CGFloat = 21
    private let conversationViewCellDataManager = ConversationViewCellDataManager()
    private var messages: [ConversationViewCellModel] = []
    
    var currentTheme = ThemesManager.currentTheme

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = conversationName
        
        setupTableView()
        registerNibs()
        obtainData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentTheme = ThemesManager.currentTheme
    }
        
    /// Setup TableView.
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.separatorStyle = .none
    }
    
    /// Register Nibs.
    private func registerNibs() {
        let cellNib = UINib(nibName: cellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    /// Obtain data.
    func obtainData() {
        messages = conversationViewCellDataManager.obtainConversationViewCellData()        
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ConversationViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: messages[indexPath.row])
        
        return cell
    }    
}
