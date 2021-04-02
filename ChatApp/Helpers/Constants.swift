//
//  Constants.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

struct Constants {
    // senderId
    static let senderId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    static var senderName = "No name"
    
    // colors
    static let userPhotoBackgrounColor = UIColor(red: 0.89, green: 0.91, blue: 0.17, alpha: 1.00)
    static let contactPhotoBackgrounColor = UIColor(red: 0.89, green: 0.91, blue: 0.17, alpha: 1.00)
    static let onlineConversationCellBackgroundColor = UIColor(red: 1.00, green: 0.99, blue: 0.86, alpha: 1.00)
    static let sentMessageViewColor = UIColor(red: 0.86, green: 0.97, blue: 0.77, alpha: 1.00)
    static let receivedMessageViewColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
    
    // font sizes
    static let navigationBarAvatarFontSize: CGFloat = 20
    static let contactAvatarFontSize: CGFloat = 24
    static let profileAvatarFontSize: CGFloat = 120
    
    // color themes
    static let classicTheme = Colors(backgroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00),
                                     onlineConversationColor: UIColor(red: 1.00, green: 0.99, blue: 0.86, alpha: 1.00),
                                     sentMessageViewColor: UIColor(red: 0.86, green: 0.97, blue: 0.77, alpha: 1.00),
                                     receivedMessageViewColor: UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00),
                                     sentMessageFontColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00),
                                     receivedMessageFontColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00),
                                     UIElementColor: UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00),
                                     tintColor: UIColor(red: 0.33, green: 0.33, blue: 0.35, alpha: 1.00),
                                     baseFontColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00),
                                     secondaryFontColor: UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1.00),
                                     userInterfaceStyle: .light,
                                     barStyle: .default)
    static let dayTheme = Colors(backgroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00),
                                 onlineConversationColor: UIColor(red: 1.00, green: 0.99, blue: 0.86, alpha: 1.00),
                                 sentMessageViewColor: UIColor(red: 0.26, green: 0.54, blue: 0.98, alpha: 1.00),
                                 receivedMessageViewColor: UIColor(red: 0.92, green: 0.92, blue: 0.93, alpha: 1.00),
                                 sentMessageFontColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00),
                                 receivedMessageFontColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00),
                                 UIElementColor: UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00),
                                 tintColor: UIColor(red: 0.33, green: 0.33, blue: 0.35, alpha: 1.00),
                                 baseFontColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00),
                                 secondaryFontColor: UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1.00),
                                 userInterfaceStyle: .light,
                                 barStyle: .default)
    static let nightTheme = Colors(backgroundColor: UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 1.00),
                                   onlineConversationColor: UIColor(red: 0.28, green: 0.29, blue: 0.22, alpha: 1.00),
                                   sentMessageViewColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.00),
                                   receivedMessageViewColor: UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.00),
                                   sentMessageFontColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00),
                                   receivedMessageFontColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00),
                                   UIElementColor: UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.00),
                                   tintColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00),
                                   baseFontColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00),
                                   secondaryFontColor: UIColor(red: 0.55, green: 0.55, blue: 0.58, alpha: 1.00),
                                   userInterfaceStyle: .dark,
                                   barStyle: .black)
    // file names
    static let nameFileName = "name.txt"
    static let descriptionFileName = "description.txt"
    static let photoFileName = "photo.txt"
    static let themeFileName = "theme.txt"
}
