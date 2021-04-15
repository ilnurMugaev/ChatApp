//
//  SaveOperation.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 18.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class SaveOperation: Operation {
    private let nameFilename = Constants.nameFileName
    private let descriptionFilename = Constants.descriptionFileName
    private let photoFilename = Constants.photoFileName
    
    let saveToFileManager: SaveToFileManagerProtocol
    var userName: String?
    var userDescription: String?
    var userPhoto: UIImage?
    var savedFields: [String: Bool] = ["name": false,
                                      "description": false,
                                      "photo": false]
    var fails = [String]()
    
    init(saveToFileManager: SaveToFileManagerProtocol, name: String?, description: String?, photo: UIImage?) {
        self.saveToFileManager = saveToFileManager
        self.userName = name
        self.userDescription = description
        self.userPhoto = photo
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
        
        saveData()
    }

    func saveData() {
        if let name = userName {
            if self.saveToFileManager.saveString(to: self.nameFilename, string: name) {
                savedFields["name"] = true
                Constants.senderName = name
                print("saved name")
            } else {
                fails.append("name")
            }
        }
        
        if let description = userDescription {
            if self.saveToFileManager.saveString(to: self.descriptionFilename, string: description) {
                savedFields["description"] = true
                print("saved description")
            } else {
                fails.append("description")
            }
        }
        
        if let photo = userPhoto,
            let photoData = photo.pngData() {
            if self.saveToFileManager.saveData(to: self.photoFilename, data: photoData) {
                savedFields["photo"] = true
                print("saved photo")
            } else {
                fails.append("photo")
            }
        }
    }
}
