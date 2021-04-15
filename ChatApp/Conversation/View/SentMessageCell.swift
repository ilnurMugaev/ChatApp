//
//  SentMessageCell.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell, ConfigurableView {

    let messageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpLayers()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpLayers() {
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        contentView.addSubview(messageView)
        messageView.addSubview(messageLabel)
        messageView.addSubview(dateLabel)
        
        messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0).isActive = true
        messageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: contentView.frame.width / 4).isActive = true
        messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0).isActive = true
        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0).isActive = true
        messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 5.0).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15.0).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15.0).isActive = true
        
        dateLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -8).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -6).isActive = true
    }
    
    func configure(with model: MessageCellModel) {
        let currentTheme = ThemeManager.currentTheme
        
        contentView.backgroundColor = currentTheme.colors.backgroundColor
        messageView.backgroundColor = currentTheme.colors.sentMessageViewColor
        
        messageLabel.textColor = currentTheme.colors.sentMessageFontColor
        messageLabel.text = model.content
        
        dateLabel.textColor = currentTheme.colors.secondaryFontColor
        dateLabel.text = model.created
    }
}
