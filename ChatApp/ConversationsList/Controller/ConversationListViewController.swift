//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 27.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit
import CoreData

class ConversationListViewController: UIViewController, ThemesPickerDelegate, AlertPresentable {
    
    @IBOutlet var tableView: UITableView!

    var updateAppearanceClosure: ((Theme) -> Void)?
    var currentTheme = ThemeManager.currentTheme {
        didSet {
            updateAppearance(theme: currentTheme)
        }
    }
    
    var user = User()
    private var saveDataManager: SaveDataManager!
    private var firebaseManager: FirebaseManager!
    private lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        fetchRequest.resultType = .managedObjectResultType
        let context = CoreDataStack.shared.mainContext

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Constants.senderId)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("Chat.sqlite") as Any)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        currentTheme = ThemeManager.currentTheme
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "conversationCell")
        
        self.updateAppearanceClosure = { [weak self] theme in
            self?.currentTheme = theme
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing fetch: \(error)")
        }
        
        firebaseManager = FirebaseManager()
        getChannels()
        
        // загрузка данных через GCD
        saveDataManager = GCDDataManager()
        // загрузка данных через Operation
//        saveDataManager = OperationDataManager()
        saveDataManager.loadData { (name, _, photo) in
            DispatchQueue.main.async {
                self.user.name = name ?? "No name"
                Constants.senderName = name ?? "No name"
                self.user.photo = photo
                
                self.configureNavigationElements()
            }
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
    
    func getChannels() {
        print("Get channels")
        firebaseManager.getChannels { (addedChannels, modifiedChannels, removedChannelsIDs) in
            CoreDataStack.shared.performSave { (context) in
                let channels = self.fetchedResultsController.fetchedObjects ?? []
                for channel in addedChannels {
                    if channels.contains(where: { $0.identifier == channel.identifier }) {
                        continue
                    } else {
                        print("performSave - add channel")
                        let channelDB = ChannelDB(context: context)
                        channelDB.identifier = channel.identifier
                        channelDB.name = channel.name
                        channelDB.lastMessage = channel.lastMessage
                        channelDB.lastActivity = channel.lastActivity
                    }
                    
                }

                for channel in modifiedChannels {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            channelDB.name = channel.name
                            channelDB.lastMessage = channel.lastMessage
                            channelDB.lastActivity = channel.lastActivity
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }

                for channelId in removedChannelsIDs {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channelId)
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            context.delete(channelDB)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell") as? ConversationCell,
            let channels = fetchedResultsController.fetchedObjects else { return ConversationCell() }
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
        
        conversationVC.channel = fetchedResultsController.fetchedObjects?[indexPath.row]
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let channel = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
            let channelId = channel.identifier
            let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            request.predicate = NSPredicate(format: "identifier = %@", channelId)
            
            CoreDataStack.shared.performSave { (context) in
                do {
                    let channelDB = try context.fetch(request).first
                    if let channelDB = channelDB {
                        context.delete(channelDB)
                        firebaseManager.deleteChannel(id: channelDB.identifier)
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            
        }
    }
}

extension ConversationListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("begin update")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("Inserted channel at line \(newIndexPath)", controller.managedObjectContext.description)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                print("Updated channel at line \(indexPath)")
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Deleted channel at line \(indexPath)")
            }
        case .move:
            if let indexPath = indexPath,
               let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("Moved channel from line \(indexPath) to line \(newIndexPath)")
            }
        @unknown default:
            print("Unknown case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("end update")
        tableView.endUpdates()
    }
}
