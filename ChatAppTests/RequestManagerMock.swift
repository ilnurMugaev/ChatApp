//
//  RequestManagerMock.swift
//  ChatAppTests
//
//  Created by Ilnur Mugaev on 01.05.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

@testable import ChatApp
import Foundation

class RequestManagerMock: RequestManagerProtocol {

    var receivedUrl = ""
    var completionStub: (((Result<Data, NetworkError>) -> Void) -> Void)!

    func sendRequest(request: UrlRequestProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.urlError))
            return
        }
        receivedUrl = urlRequest.url?.absoluteString ?? ""
        completionStub(completion)
    }
}
