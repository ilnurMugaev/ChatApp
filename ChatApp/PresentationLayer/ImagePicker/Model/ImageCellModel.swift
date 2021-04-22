//
//  ImageCellModel.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol ImageCellModelProtocol {
    func loadPhoto(urlString: String, completion: @escaping (UIImage?) -> Void)
}

class ImageCellModel: ImageCellModelProtocol {
    private let photoService: PhotoServiceProtocol
    
    init(photoService: PhotoServiceProtocol) {
        self.photoService = photoService
    }
    
    func loadPhoto(urlString: String, completion: @escaping (UIImage?) -> Void) {
        photoService.getPhoto(urlString: urlString) { (image, error) in
            if let error = error {
                
                switch error {
                case .urlError:
                    print("Failed to get URL from previewURL")
                case .requestError:
                    print("Got photo request error")
                case .dataError:
                    print("Can't get photo data")
                case .parseError:
                    print("Can't parse photo data")
                }
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }    
}
