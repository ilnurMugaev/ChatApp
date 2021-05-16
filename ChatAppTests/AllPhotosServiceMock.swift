//
//  AllPhotosServiceMock.swift
//  ChatAppTests
//
//  Created by Ilnur Mugaev on 01.05.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

@testable import ChatApp
import Foundation

class AllPhotosServiceMock: AllPhotosServiceProtocol {
    var receivedData = Data()
    let requestManager: RequestManagerProtocol
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func getAllPhotos(searchText: String, completion: @escaping ([PhotoItem]?, NetworkError?) -> Void) {
        let request = AllPhotosRequest(searchText: searchText)
        requestManager.sendRequest(request: request) { (result) in
            switch result {
            case .success(let data):
                self.receivedData = data
                completion(nil, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
