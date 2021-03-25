//
//  AlertService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol AlertPresentable {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction], completion: (() -> Void)?)
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction], completion: (() -> Void)?) {
        let currentTheme = ThemeManager.currentTheme
        let attributedTitle = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.foregroundColor: currentTheme.colors.baseFontColor,
                                                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)])
        let attributedMessage = NSAttributedString(string: message ?? "", attributes: [NSAttributedString.Key.foregroundColor: currentTheme.colors.baseFontColor,
                                                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = currentTheme.colors.UIElementColor
        
        actions.forEach { alertController.addAction($0) }

        present(alertController, animated: true, completion: completion)
    }
}
