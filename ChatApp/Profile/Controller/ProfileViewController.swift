//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 14.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, AlertPresentable {

    @IBOutlet var backgroundView: UIView!    
    @IBOutlet var editBarButton: UIBarButtonItem!
    @IBOutlet var closeBarButton: UIBarButtonItem!
    
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
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .gray
        }
        return indicator
    }()

    var imagePicker: UIImagePickerController!
    
    var user = User()
    var saveDataManager: SaveDataManager!
    var delegate: ConversationListViewController!
    
    var isEditingProfile = false
    var photoIsSame = true
    
    let avatarViewWidth = min(240.0, UIScreen.main.bounds.height * 0.3)
    let fontSize = min(120.0, UIScreen.main.bounds.height * 0.15)
    var currentTheme = ThemeManager.currentTheme
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        navigationController?.isNavigationBarHidden = false
        
        setUpSelectors()
        setUpConstraints()
        configureUIElements()
        
        // загрузка данных через GCD
        saveDataManager = GCDDataManager()
        
        // загрузка данных через Operation
//        saveDataManager = OperationDataManager()
                
        activityIndicator.startAnimating()
        saveDataManager.loadData { (name, description, photo) in
            self.user.name = name ?? "No name"
            self.user.description = description ?? "No description"
            self.user.photo = photo
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                self.nameTextField.text = self.user.name
                self.descriptionTextView.text = self.user.description
                
                self.configureAvatarView(with: self.user, fontSize: self.fontSize)
            }
        }
    }
    
    func setUpSelectors() {
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (avatarTapped(_:))))
        saveWithGCDButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        saveWithOperationButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func setUpConstraints() {
        backgroundView.addSubview(avatarView)
        backgroundView.addSubview(nameTextField)
        backgroundView.addSubview(descriptionTextView)
        backgroundView.addSubview(saveWithGCDButton)
        backgroundView.addSubview(saveWithOperationButton)
        backgroundView.addSubview(activityIndicator)
        
        let avatarViewConstraints = [avatarView.heightAnchor.constraint(equalToConstant: avatarViewWidth),
                                     avatarView.widthAnchor.constraint(equalToConstant: avatarViewWidth),
                                     avatarView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                                     avatarView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 7)]
        let nameTextFieldConstraints = [nameTextField.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 32),
                                        nameTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30),
                                        nameTextField.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                                        nameTextField.heightAnchor.constraint(equalToConstant: 30)]
        let descriptionTextViewConstraints = [descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
                                              descriptionTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 50),
                                              descriptionTextView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)]
        let saveWithGCDButtonConstraints = [saveWithGCDButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 5),
                                            saveWithGCDButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 56),
                                            saveWithGCDButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                                            saveWithGCDButton.heightAnchor.constraint(equalToConstant: 40)]
        let saveWithOperationButtonConstraints = [saveWithOperationButton.topAnchor.constraint(equalTo: saveWithGCDButton.bottomAnchor, constant: 10),
                                                   saveWithOperationButton.leadingAnchor.constraint(equalTo: saveWithGCDButton.leadingAnchor),
                                                   saveWithOperationButton.centerXAnchor.constraint(equalTo: saveWithGCDButton.centerXAnchor),
                                                   saveWithOperationButton.heightAnchor.constraint(equalToConstant: 40),
                                                   saveWithOperationButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -30)]
        let activityIndicatorConstraints = [activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)]
        
        NSLayoutConstraint.activate(avatarViewConstraints)
        NSLayoutConstraint.activate(nameTextFieldConstraints)
        NSLayoutConstraint.activate(descriptionTextViewConstraints)
        NSLayoutConstraint.activate(saveWithGCDButtonConstraints)
        NSLayoutConstraint.activate(saveWithOperationButtonConstraints)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
    }
    
    func configureUIElements() {
        self.backgroundView.backgroundColor = currentTheme.colors.backgroundColor
        editBarButton.tintColor = .systemBlue
        closeBarButton.tintColor = .systemBlue
        
        avatarView.isUserInteractionEnabled = true
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        
        nameTextField.textColor = currentTheme.colors.baseFontColor
        nameTextField.isEnabled = false
        descriptionTextView.textColor = currentTheme.colors.baseFontColor
        descriptionTextView.backgroundColor = currentTheme.colors.backgroundColor
        descriptionTextView.isEditable = false
        
        saveWithGCDButton.backgroundColor = currentTheme.colors.UIElementColor
        saveWithGCDButton.setTitleColor(currentTheme.colors.secondaryFontColor, for: .normal)
        saveWithGCDButton.isEnabled = false
        saveWithOperationButton.backgroundColor = currentTheme.colors.UIElementColor
        saveWithOperationButton.setTitleColor(currentTheme.colors.secondaryFontColor, for: .normal)
        saveWithOperationButton.isEnabled = false
        
        activityIndicator.hidesWhenStopped = true
    }
    
    func configureAvatarView(with user: User, fontSize: CGFloat) {
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        avatarView.configure(image: user.photo, name: user.name, fontSize: fontSize, cornerRadius: avatarViewWidth / 2)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        isEditingProfile.toggle()
        
        editBarButton.title = "Edit"
        nameTextField.isEnabled = false
        nameTextField.borderStyle = .none
        
        descriptionTextView.isEditable = false
        descriptionTextView.layer.borderWidth = 0.0
        
        compareFields()
    }
    
    @objc func avatarTapped(_ sender: Any) {
        let choosePhotoAction = UIAlertAction(title: "Choose photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.showAlert(title: "Error", message: "No access to Photo Library", preferredStyle: .alert, actions: [okAction], completion: nil)
            }

        }
        let takePhotoAction = UIAlertAction(title: "Take photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .front
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.showAlert(title: "Error", message: "Camera is not available", preferredStyle: .alert, actions: [okAction], completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let message = "Please choose one of the ways"
        self.showAlert(title: "Edit photo", message: message, preferredStyle: .actionSheet, actions: [choosePhotoAction, takePhotoAction, cancelAction], completion: nil)
    }
    
    @IBAction func editBarButtonPressed(_ sender: Any) {
        isEditingProfile.toggle()
        
        if isEditingProfile {
            editBarButton.title = "Cancel"
            
            nameTextField.isEnabled = true
            nameTextField.borderStyle = .line
            nameTextField.layer.borderColor = currentTheme.colors.secondaryFontColor.cgColor
            
            descriptionTextView.isEditable = true
            descriptionTextView.layer.borderWidth = 1.0
            descriptionTextView.layer.borderColor = currentTheme.colors.secondaryFontColor.cgColor
        } else {
            editBarButton.title = "Edit"
            nameTextField.isEnabled = false
            nameTextField.borderStyle = .none
            
            descriptionTextView.isEditable = false
            descriptionTextView.layer.borderWidth = 0.0
            
            compareFields()
        }
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func compareFields() {
        let name = nameTextField.text
        let description = descriptionTextView.text
        
        if (name != self.user.name) || (description != self.user.description) || (!photoIsSame) {
            self.saveWithGCDButton.setTitleColor(.systemBlue, for: .normal)
            self.saveWithGCDButton.isEnabled = true
            self.saveWithOperationButton.setTitleColor(.systemBlue, for: .normal)
            self.saveWithOperationButton.isEnabled = true
        } else {
            self.saveWithGCDButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
            self.saveWithGCDButton.isEnabled = false
            self.saveWithOperationButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
            self.saveWithOperationButton.isEnabled = false
        }
    }

    @objc func saveButtonPressed(_ sender: Any) {
        let tag = (sender as? UIButton)?.tag ?? 0
        saveToFile(tag: tag)
    }
    
    func saveToFile(tag: Int) {
        
        activityIndicator.startAnimating()
        
        self.backgroundView.isUserInteractionEnabled = false
        self.saveWithGCDButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
        self.saveWithGCDButton.isEnabled = false
        self.saveWithOperationButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
        self.saveWithOperationButton.isEnabled = false
        
        let name = (nameTextField.text == user.name) ? nil : nameTextField.text
        let description = (descriptionTextView.text == user.description) ? nil : descriptionTextView.text
        let photo = photoIsSame ? nil : avatarView.imageView.image
        
        if tag == 0 {
            saveDataManager = GCDDataManager()
        } else if tag == 1 {
            saveDataManager = OperationDataManager()
        }
        
        saveDataManager.saveData(name: name, description: description, photo: photo) { (savedFields, fails) in
            self.activityIndicator.stopAnimating()
            self.savingCompletionBlock(savedFields: savedFields, fails: fails, tag: tag)
        }
    }
    
    func savingCompletionBlock(savedFields: [String: Bool], fails: [String], tag: Int) {
        if savedFields["name"]! {
            self.user.name = self.nameTextField.text
        }
        if savedFields["description"]! {
            self.user.description = self.descriptionTextView.text
        }
        if savedFields["photo"]! {
            self.user.photo = self.avatarView.imageView.image
            photoIsSame = true
        }
        
        if fails.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            self.showAlert(title: "Data saved", message: nil, preferredStyle: .alert, actions: [okAction], completion: nil)
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.saveWithGCDButton.setTitleColor(.systemBlue, for: .normal)
                self.saveWithGCDButton.isEnabled = true
                self.saveWithOperationButton.setTitleColor(.systemBlue, for: .normal)
                self.saveWithOperationButton.isEnabled = true
            }
            let repeatAction = UIAlertAction(title: "Try again", style: .default) { _ in
                self.saveToFile(tag: tag)
            }
            
            let message = fails.joined(separator: ", ")
            self.showAlert(title: "Error", message: "Failed to save \(message)", preferredStyle: .alert, actions: [okAction, repeatAction], completion: nil)
        }
        self.backgroundView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate.user = user
        delegate.configureNavigationElements()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var newPhoto = UIImage()
        
        if let photo = info[.editedImage] as? UIImage {
            newPhoto = photo
        } else if let photo = info[.originalImage] as? UIImage {
            newPhoto = photo
        } else {
            return
        }
        
        dismiss(animated: true, completion: nil)
        avatarView.configure(image: newPhoto, cornerRadius: avatarViewWidth / 2)
        
        let queue = DispatchQueue.global()
        queue.async {
            if newPhoto.pngData() == self.user.photo?.pngData() {
                self.photoIsSame = true
            } else {
                self.photoIsSame = false
            }
            
            DispatchQueue.main.async {
                self.compareFields()
            }
        }
    }
}
