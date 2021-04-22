//
//  AllPhotosService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

struct PhotoApiModel: Decodable {
    let hits: [PhotoItem]
}

struct PhotoItem: Decodable {
    let previewURL: String
    let webformatURL: String
}

protocol AllPhotosServiceProtocol {
    func getAllPhotos(searchText: String, completion: @escaping([PhotoItem]?, NetworkError?) -> Void)
}

class AllPhotosService: AllPhotosServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getAllPhotos(searchText: String, completion: @escaping([PhotoItem]?, NetworkError?) -> Void) {
        let request = AllPhotosRequest(searchText: searchText)
        
        requestManager.sendRequest(request: request) { (result) in
            
            switch result {
            case .success(let data):
                do {
                    let allPhotos = try JSONDecoder().decode(PhotoApiModel.self, from: data)
                    let photoItems = allPhotos.hits
                    completion(photoItems, nil)
                } catch {
                    completion(nil, .parseError)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
