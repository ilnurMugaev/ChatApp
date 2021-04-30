//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var firebaseManager: FirebaseManagerProtocol { get }
    var coreDataManager: CoreDataManagerProtocol { get }
    var saveToFileManager: SaveToFileManagerProtocol { get }
    var fetchManager: FetchManagerProtocol { get }
    var requestManager: RequestManagerProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var firebaseManager: FirebaseManagerProtocol = FirebaseManager()
    lazy var coreDataManager: CoreDataManagerProtocol = CoreDataManager()
    lazy var saveToFileManager: SaveToFileManagerProtocol = SaveToFileManager()
    lazy var fetchManager: FetchManagerProtocol = FetchManager(coreDataManager: self.coreDataManager)
    lazy var requestManager: RequestManagerProtocol = RequestManager(urlSession: URLSession.shared)
}
