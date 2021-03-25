//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 03.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITextViewDelegate, AlertPresentable {

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 1.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var sendView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var sendTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 18
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset.left = 17
        textView.textContainerInset.right = 50
        return textView
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_send"), for: .normal)
        return button
    }()
    
    var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        label.text = "Your message here..."
        return label
    }()
    
    var channel: Channel?
    private var messages = [Message]()
    var currentTheme = ThemeManager.currentTheme
    private var firebaseManager: FirebaseManager!
    
    private var textHeightConstraint: NSLayoutConstraint!
    private var maxTextHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = channel?.name
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SentMessageCell.self, forCellReuseIdentifier: "sentMessageCell")
        tableView.register(ReceivedMessageCell.self, forCellReuseIdentifier: "receivedMessageCell")
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.backgroundView = setUpBackgroundLabel()
        
        sendTextView.delegate = self
        
        sendButton.isUserInteractionEnabled = false
        sendButton.isHidden = true
        
        placeholderLabel.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        sendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        
        firebaseManager = FirebaseManager()
        if let channel = self.channel {
            firebaseManager.getMessages(with: channel.identifier) { (messages) in
                let messages = messages.sorted { $0.created.compare($1.created) == .orderedDescending }
                self.messages.insert(contentsOf: messages, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentTheme = ThemeManager.currentTheme
        setUpUppearance()
        setUpFirstLayer()
        setUpSecondLayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        self.view.backgroundColor = currentTheme.colors.backgroundColor
    }
    
    func setUpUppearance() {
        sendView.backgroundColor = currentTheme.colors.UIElementColor
        sendTextView.backgroundColor = currentTheme.colors.backgroundColor
    }
    
    func setUpFirstLayer() {
        view.addSubview(tableView)
        view.addSubview(sendView)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sendView.topAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        sendView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        sendView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        sendView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setUpSecondLayer() {
        sendView.addSubview(sendTextView)
        sendView.addSubview(sendButton)
        sendView.addSubview(placeholderLabel)
        
        sendTextView.topAnchor.constraint(equalTo: sendView.topAnchor, constant: 17).isActive = true
        sendTextView.leadingAnchor.constraint(equalTo: sendView.leadingAnchor, constant: 19).isActive = true
        sendTextView.bottomAnchor.constraint(equalTo: sendView.bottomAnchor, constant: -27).isActive = true
        sendTextView.trailingAnchor.constraint(equalTo: sendView.trailingAnchor, constant: -19).isActive = true
        
        maxTextHeightConstraint = sendTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        maxTextHeightConstraint.priority = UILayoutPriority(rawValue: 251)
        maxTextHeightConstraint.isActive = true
        
        textHeightConstraint = sendTextView.heightAnchor.constraint(equalToConstant: 36)
        textHeightConstraint.priority = UILayoutPriority(rawValue: 250)
        textHeightConstraint.isActive = true
        
        sendButton.bottomAnchor.constraint(equalTo: sendTextView.bottomAnchor, constant: -9).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: sendTextView.trailingAnchor, constant: -18).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1.0).isActive = true
        
        placeholderLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: sendTextView.leadingAnchor, constant: 20).isActive = true
        placeholderLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: sendTextView.centerYAnchor, constant: 0).isActive = true
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = sendTextView.frame.size.width
        let newSize = sendTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textHeightConstraint.constant = newSize.height
        view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let text = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        
        if !(text.replacingOccurrences(of: " ", with: "") == "") {
            sendButton.isUserInteractionEnabled = true
            sendButton.isHidden = false
        } else {
            sendButton.isUserInteractionEnabled = false
            sendButton.isHidden = true
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        adjustTextViewHeight()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func sendButtonPressed(_ sender: Any) {

        view.endEditing(true)
        
        sendButton.isUserInteractionEnabled = false
        sendButton.isHidden = true
        
        guard let text = sendTextView.text,
            let channel = self.channel else { return }
        let message = Message(content: text)
        self.sendTextView.text = ""
        textHeightConstraint.constant = 36
        placeholderLabel.isHidden = false
        firebaseManager.sendMessage(channelId: channel.identifier, message: message) { (error) in
            if error != nil {
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.showAlert(title: "Error", message: "Failed to send message", preferredStyle: .alert, actions: [okAction], completion: nil)
            }
        }
        
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.isEmpty {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView?.isHidden = true
            return messages.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let model = MessageViewModelFactory.createViewModel(with: message)
        
        if message.senderId == Constants.senderId {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sentMessageCell") as? SentMessageCell else { return SentMessageCell() }
            cell.configure(with: model)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell") as? ReceivedMessageCell else { return ReceivedMessageCell() }
            cell.configure(with: model)
            return cell
        }
    }
    
    func setUpBackgroundLabel() -> UILabel {
        let screenBounds = UIScreen.main.bounds
        let backgroundLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height))
        backgroundLabel.text = "No messages"
        backgroundLabel.font = .systemFont(ofSize: 27, weight: .semibold)
        backgroundLabel.textColor = currentTheme.colors.secondaryFontColor
        backgroundLabel.textAlignment = .center
        backgroundLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
        return backgroundLabel
    }
}
