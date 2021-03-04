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
        
        messageLabel.text = model.text
        
        if (model.isIncomingMessage) {
            messageView.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
            messageLabel.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
            leftConstraint.isActive = true
            rightConstraint.isActive = false
        } else {
            messageView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1)
            messageLabel.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1)
            leftConstraint.isActive = false
            rightConstraint.isActive = true
        }
    }
}
