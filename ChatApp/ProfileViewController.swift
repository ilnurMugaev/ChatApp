//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 14.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
        
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var nameTextView: UITextView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var editButton: UIButton!
        
    private let logging = Logging.shared
    
    private let userName = "Ilnur Mugaev"
    private let userDescription = "iOS Developer\nKazan"
        
    private lazy var userInitials: String = {
        let nameComponents = userName.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        let userInitials = nameComponents.reduce("") { ($0 == "" ? "" : "\($0.first ?? Character(" "))") + "\($1.first ?? Character(" "))" }
        return userInitials.trimmingCharacters(in: .whitespacesAndNewlines)
    }()
    
    private let buttonCornerRadius: CGFloat = 14
        
    // Срабатывает после загрузки view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logging.printLog()
        
        nameTextView.text = userName
        descriptionTextView.text = userDescription
        initialsLabel.text = userInitials
    }
    
    // Срабатывает перед появлением view на экране.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logging.printLog()
    }
        
    // Срабатывает после появлением view на экране.
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logging.printLog()
    }
    
    // Срабатывает перед тем, как размер view изменится под размер экрана.
    override func viewWillLayoutSubviews() {
        logging.printLog()
    }
    
    // Срабатывает после того, как размер view изменился под размер экрана.
    override func viewDidLayoutSubviews() {
        editButton.layer.cornerRadius = buttonCornerRadius
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        let initialsFonSize = avatarImageView.bounds.height / 2
        initialsLabel.font = UIFont.systemFont(ofSize: initialsFonSize)
        logging.printLog()
    }
        
    // Сработает перед тем, как view закроется.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logging.printLog()
    }
    
    // Сработает после того, как view закрылся.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logging.printLog()
    }
}
