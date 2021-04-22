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
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var buttons: [UIButton]!
    
    var delegate: ThemesPickerDelegate?
    var setThemeClosure: ((Theme) -> Void)?
    var selectedTheme: Theme
    private let model: ThemesModelProtocol
    
    init(model: ThemesModelProtocol) {
        self.model = model
        self.selectedTheme = model.currentTheme()
        
        super.init(nibName: "Themes", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
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
        
        model.saveTheme(theme: selectedTheme)
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTheme))
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
    
    @objc func cancelTheme() {
        selectedTheme = model.currentTheme()
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
            print(tag)
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
        
        // обновление ConversationListViewController через делегат
//        delegate?.currentTheme = theme
                
        // обновление ConversationListViewController через замыкание
        // мог бы возникнуть retain cycle ConversationListViewController -> ThemesViewController -> setThemeClosure -> ConversationListViewController,
        // но в ConversationListViewController ссылка на ThemesViewController создается в методе
        // leftBarButtonPressed, а не как переменная класса, так что цикла возникнуть не должно
        // Еще в самом ConversationListViewController мог бы за счет использования self возникнуть цикл ViewController -> updateAppearanceClosure -> ViewController,
        // но в замыкании используется [weak self], так что этого не случится.
        if let closure = setThemeClosure {
            closure(theme)
        }
    }
    
    func buttonSetSelected(button: UIButton) {
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00).cgColor
    }
    
    func buttonSetDeselected(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1.00).cgColor
    }
}
