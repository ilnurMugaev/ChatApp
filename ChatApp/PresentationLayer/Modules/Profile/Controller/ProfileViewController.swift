//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 14.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate {
    func setImage(newPhoto: UIImage)
    func startWaiting()
    func stopWaiting()
}

class ProfileViewController: UIViewController, AlertPresentableProtocol, UserInfoDelegate {

    @IBOutlet var backgroundView: ProfileView!
    @IBOutlet var editBarButton: UIBarButtonItem!
    @IBOutlet var closeBarButton: UIBarButtonItem!
    
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
    
    var currentTheme: Theme
    private let presentationAssembly: PresentationAssemblyProtocol
    private let model: ProfileModelProtocol
    
    var user = User()
    var delegate: ConversationListViewController!
    
    var isEditingProfile = false
    var photoIsSame = true
    
    init(presentationAssembly: PresentationAssemblyProtocol, model: ProfileModelProtocol) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        self.currentTheme = model.currentTheme()
        
        super.init(nibName: "Profile", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        navigationController?.isNavigationBarHidden = false
        
        setUpSelectors()
        setColors()
        setUpActivityIndicator()
        
        activityIndicator.startAnimating()
        model.loadUserData {
            self.activityIndicator.stopAnimating()
            
            self.backgroundView.nameTextField.text = self.user.name
            self.backgroundView.descriptionTextView.text = self.user.description
            
            self.backgroundView.configureAvatarView(with: self.user)
        }
    }
    
    func setUpSelectors() {
        backgroundView.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (avatarTapped(_:))))
        backgroundView.saveWithGCDButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        backgroundView.saveWithOperationButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func setColors() {
        editBarButton.tintColor = .systemBlue
        closeBarButton.tintColor = .systemBlue
        
        backgroundView.setColors(theme: currentTheme)
    }
    
    func setUpActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    // MARK: Keyboard functions
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
        backgroundView.setElementsDeselected()
        
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
        let loadPhotoAction = UIAlertAction(title: "Load photo", style: .default) {[weak self] (_) in
            let imagePickerVC = self?.presentationAssembly.imagePickerViewController()
            imagePickerVC?.delegate = self
            if let imagePickerVC = imagePickerVC {
                print("present")
                self?.present(imagePickerVC, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let message = "Please choose one of the ways"
        self.showAlert(title: "Edit photo",
                       message: message,
                       preferredStyle: .actionSheet,
                       actions: [choosePhotoAction, takePhotoAction, loadPhotoAction, cancelAction],
                       completion: nil)
    }
    
    @IBAction func editBarButtonPressed(_ sender: Any) {
        isEditingProfile.toggle()
        
        if isEditingProfile {
            editBarButton.title = "Cancel"
            
            backgroundView.setElementsSelected()
        } else {
            editBarButton.title = "Edit"
            backgroundView.setElementsDeselected()
            
            compareFields()
        }
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func compareFields() {
        let name = backgroundView.nameTextField.text
        let description = backgroundView.descriptionTextView.text
        
        if (name != self.user.name) || (description != self.user.description) || (!photoIsSame) {
            backgroundView.buttonsEnabled()
        } else {
            backgroundView.buttonsDisabled(theme: currentTheme)
        }
    }

    // MARK: Saving data
    @objc func saveButtonPressed(_ sender: Any) {
        let tag = (sender as? UIButton)?.tag ?? 0
        saveToFile(tag: tag)
    }
    
    func saveToFile(tag: Int) {
        activityIndicator.startAnimating()
        
        backgroundView.isUserInteractionEnabled = false
        backgroundView.buttonsDisabled(theme: currentTheme)
        
        let name = (backgroundView.nameTextField.text == user.name) ? nil : backgroundView.nameTextField.text
        let description = (backgroundView.descriptionTextView.text == user.description) ? nil : backgroundView.descriptionTextView.text
        let photo = photoIsSame ? nil : backgroundView.avatarView.imageView.image
        
        model.saveUserData(tag: tag, name: name, description: description, photo: photo) { (savedFields, fails) in
            self.savingCompletionBlock(savedFields: savedFields, fails: fails, tag: tag)
        }
    }
    
    func savingCompletionBlock(savedFields: [String: Bool], fails: [String], tag: Int) {
        self.activityIndicator.stopAnimating()
        
        if savedFields["name"]! {
            self.user.name = backgroundView.nameTextField.text
        }
        if savedFields["description"]! {
            self.user.description = backgroundView.descriptionTextView.text
        }
        if savedFields["photo"]! {
            self.user.photo = backgroundView.avatarView.imageView.image
            photoIsSame = true
        }
        
        if fails.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            self.showAlert(title: "Data saved", message: nil, preferredStyle: .alert, actions: [okAction], completion: nil)
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.backgroundView.buttonsEnabled()
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
        setImage(newPhoto: newPhoto)
    }
}

extension ProfileViewController: ImagePickerDelegate {
    func setImage(newPhoto: UIImage) {
        backgroundView.configureAvatarView(with: newPhoto)
        
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
    
    func startWaiting() {
        backgroundView.visualEffectView.isHidden = false
        backgroundView.avatarViewActivityIndicator.startAnimating()
    }
    
    func stopWaiting() {
        backgroundView.visualEffectView.isHidden = true
        backgroundView.avatarViewActivityIndicator.stopAnimating()
    }
}
