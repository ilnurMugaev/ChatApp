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
    private let actionSheetTitle = "Choose your profile photo"
    private let cameraTitle = "Camera"
    private let photoTitle = "Photo"
    private let cancelTitle = "Cancel"
    
        
    // Срабатывает после загрузки view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logging.printLog()
        
        nameTextView.text = userName
        descriptionTextView.text = userDescription
        initialsLabel.text = userInitials
        editButton.layer.cornerRadius = buttonCornerRadius
        
        setupGestures()
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
        logging.printLog()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        let initialsFonSize = avatarImageView.bounds.height / 2
        initialsLabel.font = UIFont.systemFont(ofSize: initialsFonSize)
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
    
    // MARK: - Setup gesters -
    
    private func setupGestures() {
        
        avatarImageView.isUserInteractionEnabled = true
        let avatarGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnImageView(_:)))
        avatarImageView.addGestureRecognizer(avatarGesture)
    }
    
    @objc private func tappedOnImageView(_ sender: UIGestureRecognizer) {
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: actionSheetTitle,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: cameraTitle, style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: photoTitle, style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        actionSheet.pruneNegativeWidthConstraints()
        
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - Work with image -

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Choose image:
    /// - Parameter source: source type.
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        avatarImageView.image = info[.editedImage] as? UIImage
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        initialsLabel.isHidden = true
        dismiss(animated: true)
    }
}

//MARK: - Fix break constraint UIActionSheet -

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
