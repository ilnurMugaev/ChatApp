//
//  ProfileView.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 15.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    var avatarView: AvatarView = {
        let view = AvatarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.userPhotoBackgrounColor
        return view
    }()
    
    var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        tf.textAlignment = .center
        return tf
    }()
    
    var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    var saveWithGCDButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        button.setTitle("Save with GCD", for: .normal)
        button.tag = 0
        return button
    }()
    
    var saveWithOperationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        button.setTitle("Save with Operation", for: .normal)
        button.tag = 1
        return button
    }()
    
    let avatarViewWidth = min(240.0, UIScreen.main.bounds.height * 0.3)
    let fontSize = min(120.0, UIScreen.main.bounds.height * 0.15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
        setUpElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpConstraints()
        setUpElements()
    }
    
    func setUpConstraints() {
        self.addSubview(avatarView)
        self.addSubview(nameTextField)
        self.addSubview(descriptionTextView)
        self.addSubview(saveWithGCDButton)
        self.addSubview(saveWithOperationButton)
        
        let avatarViewConstraints = [avatarView.heightAnchor.constraint(equalToConstant: avatarViewWidth),
                                     avatarView.widthAnchor.constraint(equalToConstant: avatarViewWidth),
                                     avatarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     avatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7)]
        let nameTextFieldConstraints = [nameTextField.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 32),
                                        nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
                                        nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                        nameTextField.heightAnchor.constraint(equalToConstant: 30)]
        let descriptionTextViewConstraints = [descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
                                              descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
                                              descriptionTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor)]
        let saveWithGCDButtonConstraints = [saveWithGCDButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 5),
                                            saveWithGCDButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56),
                                            saveWithGCDButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                            saveWithGCDButton.heightAnchor.constraint(equalToConstant: 40)]
        let saveWithOperationButtonConstraints = [saveWithOperationButton.topAnchor.constraint(equalTo: saveWithGCDButton.bottomAnchor, constant: 10),
                                                   saveWithOperationButton.leadingAnchor.constraint(equalTo: saveWithGCDButton.leadingAnchor),
                                                   saveWithOperationButton.centerXAnchor.constraint(equalTo: saveWithGCDButton.centerXAnchor),
                                                   saveWithOperationButton.heightAnchor.constraint(equalToConstant: 40),
                                                   saveWithOperationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)]
        
        NSLayoutConstraint.activate(avatarViewConstraints)
        NSLayoutConstraint.activate(nameTextFieldConstraints)
        NSLayoutConstraint.activate(descriptionTextViewConstraints)
        NSLayoutConstraint.activate(saveWithGCDButtonConstraints)
        NSLayoutConstraint.activate(saveWithOperationButtonConstraints)
    }
    
    func configureAvatarView(with user: User) {
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        avatarView.configure(image: user.photo, name: user.name, fontSize: fontSize, cornerRadius: avatarViewWidth / 2)
    }
    
    func configureAvatarView(with image: UIImage) {
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        avatarView.configure(image: image, cornerRadius: avatarViewWidth / 2)
    }
    
    func setUpElements() {
        avatarView.isUserInteractionEnabled = true
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        
        nameTextField.isEnabled = false
        descriptionTextView.isEditable = false
        saveWithGCDButton.isEnabled = false
        saveWithOperationButton.isEnabled = false
    }
    
    func setColors(theme: Theme) {
        self.backgroundColor = theme.colors.backgroundColor
        
        nameTextField.textColor = theme.colors.baseFontColor
        nameTextField.layer.borderColor = theme.colors.secondaryFontColor.cgColor
        
        descriptionTextView.textColor = theme.colors.baseFontColor
        descriptionTextView.backgroundColor = theme.colors.backgroundColor
        descriptionTextView.layer.borderColor = theme.colors.secondaryFontColor.cgColor
        
        saveWithGCDButton.backgroundColor = theme.colors.UIElementColor
        saveWithGCDButton.setTitleColor(theme.colors.secondaryFontColor, for: .normal)
        
        saveWithOperationButton.backgroundColor = theme.colors.UIElementColor
        saveWithOperationButton.setTitleColor(theme.colors.secondaryFontColor, for: .normal)
    }
    
    func setElementsSelected() {
        nameTextField.isEnabled = true
        nameTextField.borderStyle = .line
        
        descriptionTextView.isEditable = true
        descriptionTextView.layer.borderWidth = 1.0
    }
    
    func setElementsDeselected() {
        nameTextField.isEnabled = false
        nameTextField.borderStyle = .none
        
        descriptionTextView.isEditable = false
        descriptionTextView.layer.borderWidth = 0.0
    }
    
    func buttonsEnabled() {
        saveWithGCDButton.setTitleColor(.systemBlue, for: .normal)
        saveWithGCDButton.isEnabled = true
        saveWithOperationButton.setTitleColor(.systemBlue, for: .normal)
        saveWithOperationButton.isEnabled = true
    }
    
    func buttonsDisabled(theme: Theme) {
        saveWithGCDButton.setTitleColor(theme.colors.secondaryFontColor, for: .normal)
        saveWithGCDButton.isEnabled = false
        saveWithOperationButton.setTitleColor(theme.colors.secondaryFontColor, for: .normal)
        saveWithOperationButton.isEnabled = false
    }
}
