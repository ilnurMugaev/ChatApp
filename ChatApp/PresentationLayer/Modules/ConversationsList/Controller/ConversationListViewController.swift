//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 27.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController,
                                      ThemesPickerDelegate,
                                      AlertPresentableProtocol,
                                      ChannelsFetchedResultsServiceDelegate,
                                      UserInfoDelegate,
                                      UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!

    var updateAppearanceClosure: ((Theme) -> Void)?
    var currentTheme: Theme {
        didSet {
            updateAppearance(theme: currentTheme)
        }
    }
    var userAvatarViewSnaphot: UIView?
    var navigationBarFrame: CGRect?
    
    var user = User()
    private let presentationAssembly: PresentationAssemblyProtocol
    private var model: ConversationListModelProtocol
    private var emitter: EmitterAnimationService?
    
    init(presentationAssembly: PresentationAssemblyProtocol,
         model: ConversationListModelProtocol) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        
        self.currentTheme = model.currentTheme()
        super.init(nibName: "ConversationList", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Constants.senderId)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("Chat.sqlite") as Any)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationBarFrame = navigationController?.navigationBar.frame
        
        emitter = EmitterAnimationService(vc: self)
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "conversationCell")
        tableView.delegate = model.dataProvider
        tableView.dataSource = model.dataProvider
        NotificationCenter.default.addObserver(self, selector: #selector(showMessages(withNotification:)),
                                               name: NSNotification.Name(rawValue: "DidSelectRow notification"),
                                               object: nil)
        
        addSelectors()
        
        self.updateAppearanceClosure = { [weak self] theme in
            self?.currentTheme = theme
        }
        
        model.makeFetchedResultsController()
        model.getChannels()
        model.loadUserData {
            self.configureNavigationElements()
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
        userAvatarViewSnaphot = userAvatarView.snapshotView(afterScreenUpdates: true)
        
        let profileRightBarButton = UIBarButtonItem(customView: userButton)
        profileRightBarButton.accessibilityIdentifier = "profileButton"
        let addChannelRightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannelBarButtonPressed))
        
        let settingsLeftBarBurron = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsLeftBarButtonPressed))
                
        self.navigationItem.leftBarButtonItem = settingsLeftBarBurron
        self.navigationItem.rightBarButtonItems = [profileRightBarButton, addChannelRightBarButton]
        self.navigationItem.title = "Tinkoff Chat"
    }
    
    func updateAppearance(theme: Theme) {
        model.setTheme(theme: theme)
        tableView.reloadData()
    }
    
    func addSelectors() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.cancelsTouchesInView = false
        pan.delegate = self
        
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        touchDown.minimumPressDuration = 0
        touchDown.cancelsTouchesInView = false
        touchDown.delegate = self
        
        tableView.addGestureRecognizer(pan)
        tableView.addGestureRecognizer(touchDown)
    }
    
    @objc func settingsLeftBarButtonPressed(_ sender: Any) {
        let themesVC = presentationAssembly.themesViewController()
        
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
            if let channelName = alertController.textFields?.first?.text {
                self.model.addChannel(in: self, channelName: channelName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func profileBarButtonPressed() {
        let profileVC = presentationAssembly.profileViewController()
        profileVC.delegate = self
        profileVC.transitioningDelegate = self
        profileVC.modalPresentationStyle = .fullScreen
        
        present(profileVC, animated: true, completion: nil)
    }
    
    @objc func showMessages(withNotification notification: Notification) {
        guard let userInfo = notification.userInfo,
            let channel = userInfo["channel"] as? ChannelDB else { return }
        let conversationVC = presentationAssembly.conversatioViewController()
        conversationVC.channel = channel
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    // MARK: Emitter
    @objc func handleTap(_ sender: UILongPressGestureRecognizer) {
        emitter?.handleTap(sender)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        emitter?.handlePan(sender)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

    // MARK: Animation
extension ConversationListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let conversationListVC = source as? ConversationListViewController,
                let profileVC = presented as? ProfileViewController,
                let userAvatarViewSnaphot = userAvatarViewSnaphot,
                let navigationBarFrame = navigationBarFrame else { return nil }

        let animator = Animator(conversationListVC: conversationListVC, profileVC: profileVC, fromViewSnapshot: userAvatarViewSnaphot, navigationBarFrame: navigationBarFrame)
        return animator
    }
}
