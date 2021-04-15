//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 10.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate {
    var currentTheme: Theme { get set }
}

class ThemesViewController: UIViewController {

    @IBOutlet var backgroundColorVIew: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    
    var delegate: ThemesPickerDelegate?
    var setThemeClosure: ((Theme) -> Void)?
    var selectedTheme = ThemeManager.currentTheme
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavigationBar()
        setUpButtonsAndLabels()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ThemeManager.saveTheme(theme: selectedTheme)
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTheme))
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
    
    @objc func cancelTheme() {
        selectedTheme = ThemeManager.currentTheme
        updateAppearance(theme: selectedTheme)
        navigationController?.popViewController(animated: true)
    }
        
    func setUpButtonsAndLabels() {
        buttons.forEach { (button) in
            button.layer.cornerRadius = 14.0
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(setObjectSelected(_:)), for: .touchUpInside)
        }
        
        labels.forEach { (label) in
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setObjectSelected(_:))))
        }
        
        backgroundColorVIew.backgroundColor = selectedTheme.colors.receivedMessageViewColor
        setTheme(themeNo: selectedTheme.rawValue)
    }
    
    @objc func setObjectSelected(_ sender: AnyObject) {
        var tag = 0
        if sender as? UIButton != nil {
            tag = sender.tag
        } else if let labelSender = sender as? UITapGestureRecognizer,
            let label = labelSender.view as? UILabel {
            tag = label.tag
        }
        
        setTheme(themeNo: tag)
        
        selectedTheme = Theme(rawValue: tag) ?? Theme.classic
        updateAppearance(theme: selectedTheme)
    }
    
    func setTheme(themeNo: Int) {
        buttons.forEach { (button) in
            buttonSetDeselected(button: button)
        }
        
        buttonSetSelected(button: buttons[themeNo])
    }
    
    func updateAppearance(theme: Theme) {
        
        backgroundColorVIew.backgroundColor = theme.colors.receivedMessageViewColor
        
        // обновление ConversationsListViewController через делегат
        // delegate?.currentTheme = theme
        
        // обновление ConversationListViewController через замыкание
        // мог бы возникнуть retain cycle ConversationsListViewController -> ThemesViewController -> setThemeClosure ->
        // ConversationsListViewController, но в ConversationsListViewController ссылка на ThemesViewController создается в методе
        // settingsBarButtonTapped, а не как переменная класса, значит цикла возникнуть не должно. Еще в самом
        // ConversationsListViewController мог бы за счет использования self возникнуть цикл ViewController ->
        // updateAppearanceClosure -> ViewController, но в замыкании используется [weak self], значит этого не случится.
        if let closure = setThemeClosure {
            closure(theme)
        }
    }
    
    func buttonSetSelected(button: UIButton) {
        button.layer.borderWidth = 2.0
        button.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    func buttonSetDeselected(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1)
    }
}
