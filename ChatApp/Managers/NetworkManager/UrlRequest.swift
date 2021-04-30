//
//  UrlRequest.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol UrlRequestProtocol {
    var urlRequest: URLRequest? { get }
}

class AllPhotosRequest: UrlRequestProtocol {
    private var searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    private let baseUrlString = "https://pixabay.com/api/"
    var urlComponents = URLComponents(string: "https://pixabay.com/api/")
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: baseUrlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: Constants.apiKey),
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "image_type", value: Constants.imageType),
            URLQueryItem(name: "per_page", value: Constants.perPage)
        ]
        
        guard let url = urlComponents?.url else { return nil }
        print("URL: ", url)
        return URLRequest(url: url)
    }
}

class PhotoRequest: UrlRequestProtocol {
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
}
