//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 03.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITextViewDelegate, AlertPresentableProtocol, MessagesFetchedResultsServiceDelegate {
    
    @IBOutlet var conversationView: ConversationView!
    
    var channel: ChannelDB?
    var currentTheme: Theme
    private let model: ConversationModelProtocol
    
    init(model: ConversationModelProtocol) {
        self.model = model
        self.currentTheme = model.currentTheme()
        
        super.init(nibName: "Conversation", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var textHeightConstraint: NSLayoutConstraint!
    private var maxTextHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = channel?.name
        navigationItem.largeTitleDisplayMode = .never
                
        conversationView.tableView.delegate = model.dataProvider
        conversationView.tableView.dataSource = model.dataProvider

        conversationView.tableView.backgroundView = setUpBackgroundLabel()
        conversationView.tableView.separatorStyle = .none
    
        conversationView.sendTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        conversationView.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        conversationView.sendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        
        model.makeFetchedResultsController(channelIdentifier: channel?.identifier)
        model.getMessages(channelId: channel?.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentTheme = model.currentTheme()
        setUpUppearance()
        setUpHeightConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.backgroundColor = currentTheme.colors.backgroundColor
    }
    
    func setUpUppearance() {
        conversationView.sendView.backgroundColor = currentTheme.colors.UIElementColor
        conversationView.sendTextView.backgroundColor = currentTheme.colors.backgroundColor
    }
    
    func setUpHeightConstraints() {
        maxTextHeightConstraint = conversationView.sendTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        maxTextHeightConstraint.priority = UILayoutPriority(rawValue: 251)
        maxTextHeightConstraint.isActive = true
        
        textHeightConstraint = conversationView.sendTextView.heightAnchor.constraint(equalToConstant: 36)
        textHeightConstraint.priority = UILayoutPriority(rawValue: 250)
        textHeightConstraint.isActive = true
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
    
    // MARK: textView functions
    func adjustTextViewHeight() {
        let fixedWidth = conversationView.sendTextView.frame.size.width
        let newSize = conversationView.sendTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textHeightConstraint.constant = newSize.height
        view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let text = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        
        if !(text.replacingOccurrences(of: " ", with: "") == "") {
            conversationView.sendButton.isUserInteractionEnabled = true
            conversationView.sendButton.isHidden = false
        } else {
            conversationView.sendButton.isUserInteractionEnabled = false
            conversationView.sendButton.isHidden = true
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        conversationView.placeholderLabel.isHidden = !textView.text.isEmpty
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
        
        conversationView.sendButton.isUserInteractionEnabled = false
        conversationView.sendButton.isHidden = true
        
        guard let text = conversationView.sendTextView.text,
            let channel = self.channel else { return }
        
        print("send text: \(text)")
        model.sendMessage(in: self, channelId: channel.identifier, text: text)
        
        conversationView.sendTextView.text = ""
        textHeightConstraint.constant = 36
        conversationView.placeholderLabel.isHidden = false
    }
}
