//
//  ConversationView.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 15.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationView: UIView {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 1.0
        tableView.rowHeight = UITableView.automaticDimension
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpFirstLayer()
        setUpSecondLayer()
        setUpElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpFirstLayer()
        setUpSecondLayer()
        setUpElements()
    }
    
    func setUpFirstLayer() {
        self.addSubview(tableView)
        self.addSubview(sendView)
        
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sendView.topAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        sendView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        sendView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        sendView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    func setUpSecondLayer() {
        sendView.addSubview(sendTextView)
        sendView.addSubview(sendButton)
        sendView.addSubview(placeholderLabel)
        
        sendTextView.topAnchor.constraint(equalTo: sendView.topAnchor, constant: 17).isActive = true
        sendTextView.leadingAnchor.constraint(equalTo: sendView.leadingAnchor, constant: 19).isActive = true
        sendTextView.bottomAnchor.constraint(equalTo: sendView.bottomAnchor, constant: -27).isActive = true
        sendTextView.trailingAnchor.constraint(equalTo: sendView.trailingAnchor, constant: -19).isActive = true
        
        sendButton.bottomAnchor.constraint(equalTo: sendTextView.bottomAnchor, constant: -9).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: sendTextView.trailingAnchor, constant: -18).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1.0).isActive = true
        
        placeholderLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: sendTextView.leadingAnchor, constant: 20).isActive = true
        placeholderLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: sendTextView.centerYAnchor, constant: 0).isActive = true
    }
    
    func setUpElements() {
        tableView.register(SentMessageCell.self, forCellReuseIdentifier: "sentMessageCell")
        tableView.register(ReceivedMessageCell.self, forCellReuseIdentifier: "receivedMessageCell")

        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        sendButton.isUserInteractionEnabled = false
        sendButton.isHidden = true
        placeholderLabel.isHidden = false
    }

}
