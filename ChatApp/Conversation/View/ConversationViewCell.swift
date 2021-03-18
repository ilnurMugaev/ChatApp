//
//  ConversationViewCell.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 03.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ConversationViewCell: UITableViewCell {
    
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    private let cornerRadius: CGFloat = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = cornerRadius
    }

    /// Fills cell fields with information from the received model:
    /// - Parameter model: Received model for the cell.
    func configure(with model: ConversationViewCellModel) {
        
        let currentTheme = ThemesManager.currentTheme
        contentView.backgroundColor = currentTheme.colors.backgroundColor
        
        messageLabel.text = model.text
        
        if model.isIncomingMessage {
            messageView.backgroundColor = currentTheme.colors.incomingMessageViewColor
            messageLabel.backgroundColor = currentTheme.colors.incomingMessageViewColor
            messageLabel.textColor = currentTheme.colors.incomingMessageFontColor
            
            leftConstraint.isActive = true
            rightConstraint.isActive = false
        } else {
            messageView.backgroundColor = currentTheme.colors.outgoingMessageViewColor
            messageLabel.backgroundColor = currentTheme.colors.outgoingMessageViewColor
            messageLabel.textColor = currentTheme.colors.outgoingMessageFontColor
            
            leftConstraint.isActive = false
            rightConstraint.isActive = true
        }
    }
}
