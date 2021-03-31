//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 27.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController, ThemesPickerDelegate, AlertPresentable {
    
    @IBOutlet var tableView: UITableView!

    var updateAppearanceClosure: ((Theme) -> Void)?
    var currentTheme = ThemeManager.currentTheme {
        didSet {
            updateAppearance(theme: currentTheme)
        }
    }
    
    var user = User()
    private var channels = [Channel]()
    private var saveDataManager: SaveDataManager!
    private var firebaseManager: FirebaseManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Constants.senderId)
        navigationController?.navigationBar.prefersLargeTitles = true
        currentTheme = ThemeManager.currentTheme
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "conversationCell")
        
        self.updateAppearanceClosure = { [weak self] theme in
            self?.currentTheme = theme
        }
        
        firebaseManager = FirebaseManager()
        
        //загрузка данных через GCD
        saveDataManager = GCDDataManager()
        //загрузка данных через Operation
//        saveDataManager = OperationDataManager()
        saveDataManager.loadData { (name, _, photo) in
            DispatchQueue.main.async {
                self.user.name = name ?? "No name"
                Constants.senderName = name ?? "No name"
                self.user.photo = photo
                
                self.configureNavigationElements()
            }
        }
        
        firebaseManager.getChannels { (addedChannels, modifiedChannels, removedChannelsIDs) in
            for channel in addedChannels {
                self.channels.append(channel)
            }
            for channel in modifiedChannels {
                if let oldChannelIndex = self.channels.firstIndex(where: {$0.identifier == channel.identifier}) {
                    self.channels.remove(at: oldChannelIndex)
                    self.channels.append(channel)
                }
            }
            for channelId in removedChannelsIDs {
                if let oldChannelIndex = self.channels.firstIndex(where: {$0.identifier == channelId}) {
                    self.channels.remove(at: oldChannelIndex)
                }
            }
            
            let currentDate = Date()
            self.channels.sort { ($0.lastActivity ?? currentDate).compare($1.lastActivity ?? currentDate) == .orderedDescending }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func configureNavigationElements() {
        let userButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let userAvatarView = AvatarView(frame: userButton.frame)
        userAvatarView.backgroundColor = Constants.userPhotoBackgrounColor
        userAvatarView.layer.cornerRadius = userAvatarView.frame.width / 2
        userAvatarView.configure(image: user.photo, name: user.name, fontSize: Constants.navigationBarAvatarFontSize, cornerRadius: userAvatarView.frame.width / 2)
        userAvatarView.isUserInteractionEnabled = true
        userAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileBarButtonPressed)))
        
        userButton.addSubview(userAvatarView)
        
        let profileRightBarButton = UIBarButtonItem(customView: userButton)
        let addChannelRightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannelBarButtonPressed))
        
        let settingsLeftBarBurron = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsLeftBarButtonPressed))
        
        
        self.navigationItem.leftBarButtonItem = settingsLeftBarBurron
        self.navigationItem.rightBarButtonItems = [profileRightBarButton, addChannelRightBarButton]
    }
    
    func updateAppearance(theme: Theme) {
        ThemeManager.applyTheme(theme: theme)
        ThemeManager.updateWindows()
        tableView.reloadData()
    }
    
    @objc func settingsLeftBarButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Themes", bundle: nil)
        guard let themesVC = storyboard.instantiateViewController(withIdentifier: "themesVC") as? ThemesViewController else { return }
        
        themesVC.delegate = self
        if let closure = updateAppearanceClosure {
            themesVC.setThemeClosure = closure
        }
        navigationController?.pushViewController(themesVC, animated: true)
    }
    
    @objc func addChannelBarButtonPressed() {
        let alertController = UIAlertController(title: "Add channel", message: nil, preferredStyle: .alert)
        alertController.addTextField { (tf) in
            tf.placeholder = "Enter hannel name"
        }
        
        let  createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            if let channelName = alertController.textFields?.first?.text,
               !channelName.isEmpty,
               !(channelName.replacingOccurrences(of: " ", with: "") == "") {
                   self.firebaseManager.addChannel(name: channelName) { (error) in
                       if error != nil {
                        self.showAlert(title: "Error", message: "Failed to create channel", preferredStyle: .alert, actions: [okAction], completion: nil)
                    }
                }
            } else {
                self.showAlert(title: "Error", message: "Please enter channel name", preferredStyle: .alert, actions: [okAction], completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func profileBarButtonPressed() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController else { return }
        userDetailsVC.delegate = self
        
        present(userDetailsVC, animated: true, completion: nil)
    }
}

extension ConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell") as? ConversationCell else { return ConversationCell() }
        let model = ConversationViewModelFactory.createViewModel(with: channels[indexPath.row])

        cell.setUpAppearance(with: model, theme: currentTheme)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Conversation", bundle: nil)
        guard let conversationVC = storyboard.instantiateViewController(withIdentifier: "conversationVC") as? ConversationViewController else { return }
        
        conversationVC.channel = channels[indexPath.row]
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
}
