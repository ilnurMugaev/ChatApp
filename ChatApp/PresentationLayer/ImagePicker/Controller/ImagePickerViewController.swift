//
//  ImagePickerViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController, ImagePickerModelDelegate, AlertPresentableProtocol, UIGestureRecognizerDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var closeButton: UIBarButtonItem!
    
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
    
    var photos: [PhotoItem]?
    let cellInset: CGFloat = 20
    
    var currentTheme: Theme
    var delegate: ImagePickerDelegate?
    private let model: ImagePickerModelProtocol
    private var emitter: EmitterAnimationService?
    private var cellModel: ImageCellModelProtocol
    
    init(model: ImagePickerModelProtocol, cellModel: ImageCellModelProtocol) {
        self.model = model
        self.cellModel = cellModel
        
        self.currentTheme = model.currentTheme()
        super.init(nibName: "ImagePicker", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emitter = EmitterAnimationService(vc: self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = currentTheme.colors.backgroundColor
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")

        setLayout()
        addSelectors()
        closeButton.tintColor = .systemBlue
        setUpActivityIndicator()
        activityIndicator.startAnimating()
        print("loading photos")
        model.loadPhotos(in: self)
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: cellInset, left: cellInset, bottom: cellInset, right: cellInset)
        let cellWidth = (width - cellInset * 4.0) / 3.0
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = cellInset
        layout.minimumLineSpacing = cellInset
        collectionView.collectionViewLayout = layout
    }
    
    func addSelectors() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.cancelsTouchesInView = false
        pan.delegate = self
        
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        touchDown.minimumPressDuration = 0
        touchDown.cancelsTouchesInView = false
        touchDown.delegate = self
        
        collectionView.addGestureRecognizer(touchDown)
        collectionView.addGestureRecognizer(pan)
    }
    
    func setUpActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell,
            let photos = photos else { return UICollectionViewCell() }
        cell.initModel(cellModel: cellModel)
        cell.configure(urlString: photos[indexPath.item].previewURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photos = photos else { return }
        let urlString = photos[indexPath.item].webformatURL
        
        self.delegate?.startWaiting()
        cellModel.loadPhoto(urlString: urlString) { (image) in
            self.delegate?.stopWaiting()
            guard let image = image else { return }
            self.delegate?.setImage(newPhoto: image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
