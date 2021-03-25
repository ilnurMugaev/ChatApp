//
//  ConversationCell.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

class ConversationCell: UITableViewCell, ConfigurableView {
    
    let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatarView: AvatarView = {
        let view = AvatarView()
        view.imageView.contentMode = .scaleAspectFill
        view.backgroundColor = Constants.contactPhotoBackgrounColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setUpFirstLayer()
        setUpSecondLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
    }
    
    func setUpAppearance(with model: ConversationCellModel, theme: Theme) {
        nameLabel.textColor = theme.colors.baseFontColor
        dateLabel.textColor = theme.colors.secondaryFontColor
        messageLabel.textColor = theme.colors.secondaryFontColor
    }
    
    func configure(with model: ConversationCellModel) {
        avatarView.configure(name: model.name, fontSize: Constants.contactAvatarFontSize, cornerRadius: avatarView.frame.height / 2)
        nameLabel.text = model.name
        
        if let lastActivity = model.date {
            if calendar.isDateInToday(lastActivity) {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "dd MMM"
            }
            
            dateLabel.text = dateFormatter.string(from: lastActivity)
        } else {
            dateLabel.text = ""
        }
        
        if let lastMessage = model.message {
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            messageLabel.text = lastMessage
        } else {
            messageLabel.font = UIFont.italicSystemFont(ofSize: 13)
            messageLabel.text = "No messages yet"
        }
    }
    
    func setUpFirstLayer() {
        contentView.addSubview(bgView)
        
        bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0).isActive = true
        bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
    }
    
    func setUpSecondLayer() {
        bgView.addSubview(avatarView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(messageLabel)
        
        avatarView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        avatarView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 1.0).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 13).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -5).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .horizontal)
        
        dateLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        dateLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 13).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16).isActive = true
        messageLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 36).isActive = true
    }
}
