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

class ProfileViewController: UIViewController, AlertPresentableProtocol, UserInfoDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var backgroundColorView: UIView!
    @IBOutlet var backgroundView: ProfileView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var editBarButton: UIBarButtonItem! {
        didSet {
            let customView = UIButton()
            customView.setTitle("Edit", for: .normal)
            customView.setTitleColor(.systemBlue, for: .normal)
            customView.addTarget(self, action: #selector(editBarButtonPressed(_:)), for: .touchUpInside)
            customView.alpha = 0.0
            editBarButton.customView = customView
        }
    }
    
    @IBOutlet var closeBarButton: UIBarButtonItem! {
        didSet {
            let customView = UIButton()
            customView.setTitle("Close", for: .normal)
            customView.setTitleColor(.systemBlue, for: .normal)
            customView.addTarget(self, action: #selector(closeBarButtonPressed(_:)), for: .touchUpInside)
            customView.alpha = 0.0
            closeBarButton.customView = customView
        }
    }
    
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
    private var emitter: EmitterAnimationService?
    
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
        
        emitter = EmitterAnimationService(vc: self)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        navigationController?.isNavigationBarHidden = false
        
        addSelectors()
        setColors()
        setUpActivityIndicator()
        
        activityIndicator.startAnimating()
        model.loadUserData {
            self.activityIndicator.stopAnimating()
            
            self.backgroundView.nameTextField.text = self.user.name
            self.backgroundView.descriptionTextView.text = self.user.description
            
            self.backgroundView.configureAvatarView(with: self.user)
        }

        backgroundView.nameTextField.alpha = 0.0
        backgroundView.descriptionTextView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateUIElementsAppear()
    }
    
    func addSelectors() {
        backgroundView.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (avatarTapped(_:))))
        backgroundView.saveWithGCDButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        backgroundView.saveWithOperationButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.cancelsTouchesInView = false
        pan.delegate = self
        
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        touchDown.minimumPressDuration = 0
        touchDown.cancelsTouchesInView = false
        touchDown.delegate = self
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        backgroundView.addGestureRecognizer(touchDown)
        backgroundView.addGestureRecognizer(pan)
    }
    
    func setColors() {
        editBarButton.tintColor = .systemBlue
        closeBarButton.tintColor = .systemBlue
        
        backgroundColorView.backgroundColor = currentTheme.colors.UIElementColor
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
        stopEditBarButtonAnimation()
        
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
    
    @objc func editBarButtonPressed(_ sender: Any) {
        isEditingProfile.toggle()
        
        if isEditingProfile {
            addEditBarButtonAnimation()
            backgroundView.setElementsSelected()
        } else {
            backgroundView.setElementsDeselected()
            stopEditBarButtonAnimation()
            
            compareFields()
        }
    }
    
    @objc func closeBarButtonPressed(_ sender: Any) {
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
    
    // MARK: Emitter
    @objc func handleTap(_ sender: UILongPressGestureRecognizer) {
        emitter?.handleTap(sender)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        emitter?.handlePan(sender)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Animation
    func animateUIElementsAppear() {
        UIView.animate(withDuration: 0.3) {
            self.closeBarButton.customView?.alpha = 1.0
            self.editBarButton.customView?.alpha = 1.0
            self.backgroundView.nameTextField.alpha = 1.0
            self.backgroundView.descriptionTextView.alpha = 1.0
        }
    }
    
    func addEditBarButtonAnimation() {
        if let customView = editBarButton.customView {
            let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            let initialRotation = NSNumber(value: 0.0)
            let rotationLeft = NSNumber(value: Double.pi * 0.1)
            let rotationRight = NSNumber(value: Double.pi * -0.1)
            rotation.values = [initialRotation, rotationRight, initialRotation, rotationLeft, initialRotation]
            rotation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
            
            let upDown = CAKeyframeAnimation(keyPath: "position.y")
            let initialVertical = NSNumber(value: Int(customView.center.y))
            let up = NSNumber(value: Int(customView.center.y) + 5)
            let down = NSNumber(value: Int(customView.center.y) - 5)
            upDown.values = [initialVertical, up, initialVertical, down, initialVertical]
            upDown.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
            
            let leftRight = CAKeyframeAnimation(keyPath: "position.x")
            let initialHorizontal = NSNumber(value: Int(customView.center.x))
            let left = NSNumber(value: Int(customView.center.x) - 5)
            let right = NSNumber(value: Int(customView.center.x) + 5)
            leftRight.values = [initialHorizontal, left, initialHorizontal, right, initialHorizontal]
            leftRight.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
            
            let group = CAAnimationGroup()
            group.animations = [rotation, upDown, leftRight]
            group.duration = 0.3
            group.repeatCount = .infinity
            customView.layer.add(group, forKey: "nil")
        }
    }
    
    func stopEditBarButtonAnimation() {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.editBarButton.customView?.layer.removeAllAnimations()
        })
        
        if let customView = editBarButton.customView {
            
            let move = CABasicAnimation(keyPath: "position")
            move.fromValue = customView.layer.presentation()?.position
            move.toValue = customView.center
            move.duration = 0.3
            customView.layer.add(move, forKey: "return")
            
            CATransaction.commit()
        }
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
