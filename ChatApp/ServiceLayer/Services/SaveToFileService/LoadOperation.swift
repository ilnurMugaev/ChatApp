//
//  LoadOperation.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 18.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class LoadOperation: Operation {
    private let nameFilename = Constants.nameFileName
    private let descriptionFilename = Constants.descriptionFileName
    private let photoFilename = Constants.photoFileName
    
    let saveToFileManager: SaveToFileManagerProtocol
    var userName: String?
    var userDescription: String?
    var userPhoto: UIImage?
    
    init(saveToFileManager: SaveToFileManagerProtocol) {
        self.saveToFileManager = saveToFileManager
    }
    
    override func main() {
        
        if isCancelled {
            return
        }

        // добавил sleep для наглядности ожидания
        sleep(2)
        
        if isCancelled {
            return
        }
        
        loadData()
    }
    
    func loadData() {
        userName = saveToFileManager.loadString(from: nameFilename)
        userDescription = saveToFileManager.loadString(from: descriptionFilename)
        if let photoData = saveToFileManager.loadData(from: photoFilename) {
            userPhoto = UIImage(data: photoData)
        }
    }
}
