//
//  ImagePickerModel.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol ImagePickerModelProtocol: ThemesProtocol {
    var delegate: ImagePickerModelDelegate? { get set }
    func loadPhotos(in vc: AlertPresentableProtocol)
}

protocol ImagePickerModelDelegate: class {
    var photos: [PhotoItem]? { get set }
    var collectionView: UICollectionView! { get }
    var activityIndicator: UIActivityIndicatorView { get }
}

class ImagePickerModel: ImagePickerModelProtocol {
    weak var delegate: ImagePickerModelDelegate?
    
    private let themeService: ThemeServiceProtocol
    private let allPhotosService: AllPhotosServiceProtocol
    
    init(themeService: ThemeServiceProtocol, allPhotosService: AllPhotosServiceProtocol) {
        self.themeService = themeService
        self.allPhotosService = allPhotosService
    }
    
    func loadPhotos(in vc: AlertPresentableProtocol) {
        allPhotosService.getAllPhotos(searchText: Constants.searchText) { (photos, error) in
            DispatchQueue.main.async {
                if let error = error {
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    switch error {
                    case .urlError:
                        vc.showAlert(title: "Error", message: "Failed to get URL from URL string", preferredStyle: .alert, actions: [okAction], completion: nil)
                    case .requestError:
                        vc.showAlert(title: "Error", message: "Got request error", preferredStyle: .alert, actions: [okAction], completion: nil)
                    case .dataError:
                        vc.showAlert(title: "Error", message: "Didn't get data", preferredStyle: .alert, actions: [okAction], completion: nil)
                    case .parseError:
                        vc.showAlert(title: "Error", message: "Can't parse data", preferredStyle: .alert, actions: [okAction], completion: nil)
                    }
                }
                
                guard let photos = photos else { return }
                self.delegate?.photos = photos
                self.delegate?.activityIndicator.stopAnimating()
                self.delegate?.collectionView.reloadData()
            }
        }
    }
    
    func currentTheme() -> Theme {
        return themeService.currentTheme
    }
}
