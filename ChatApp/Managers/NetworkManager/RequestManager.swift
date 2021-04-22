//
//  RequestManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol RequestManagerProtocol {
    func sendRequest(request: UrlRequestProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case urlError
    case requestError
    case dataError
    case parseError
}

class RequestManager: RequestManagerProtocol {
    private let session: URLSession
    
    init(urlSession: URLSession) {
        self.session = urlSession
    }
    
    func sendRequest(request: UrlRequestProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.urlError))
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            print("Data from cache")
            completion(.success(cachedResponse.data))
            return
        }
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            print("Data from internet")
            if error != nil {
                completion(.failure(.requestError))
            }
            
            if let data = data {
                if let response = response {
                    self.cacheData(data: data, response: response)
                }
                completion(.success(data))
            } else {
                completion(.failure(.dataError))
            }
        }.resume()
    }
    
    private func cacheData(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
