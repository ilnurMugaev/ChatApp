//
//  ConversationsListCellModel.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 28.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

struct ConversationListCellModel {
    let name: String?
    let message: String?
    let date: Date?
    let avatar: UIImage?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
