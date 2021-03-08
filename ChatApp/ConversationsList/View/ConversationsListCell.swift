//
//  ConversationsListCell.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 27.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let cornerRadius: CGFloat = 24
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    private let regularFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    private let boldFont = UIFont.systemFont(ofSize: 13, weight: .bold)
    private let italicFont = UIFont.italicSystemFont(ofSize: 13)
    private let noMessageText = "No messages yet"
    private let defaultText = ""
    private let timeFormat = "HH:mm"
    private let dateFormat = "dd MMM"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = cornerRadius
        avatarImageView.clipsToBounds = true
    }
    
    /// Fills cell fields with information from the received model:
    /// - Parameter model: Received model for the cell.
    func configure(with model: ConversationListCellModel) {
        
        avatarImageView.image = model.avatar
        nameLabel.text = model.name
        
        if let date = model.date {
            if calendar.isDateInToday(date) {
                dateFormatter.dateFormat = timeFormat
            } else {
                dateFormatter.dateFormat = dateFormat
            }
        }
        
        if let message = model.message, !message.isEmpty, let date = model.date {
            dateLabel.text = dateFormatter.string(from: date)
            messageLabel.text = message
            messageLabel.font = model.hasUnreadMessages ? boldFont : regularFont
        } else {
            dateLabel.text = defaultText
            messageLabel.text = noMessageText
            messageLabel.font = italicFont
        }
                
        contentView.backgroundColor = model.isOnline ? #colorLiteral(red: 1, green: 0.9803921569, blue: 0.8039215686, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
