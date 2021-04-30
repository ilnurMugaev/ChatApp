//
//  PhotoService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol PhotoServiceProtocol {
    func getPhoto(urlString: String, completion: @escaping (UIImage?, NetworkError?) -> Void)
}

class PhotoService: PhotoServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getPhoto(urlString: String, completion: @escaping (UIImage?, NetworkError?) -> Void) {
        let request = PhotoRequest(urlString: urlString)
        
        requestManager.sendRequest(request: request) { (result) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image, nil)
                } else {
                    completion(nil, .parseError)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
