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
    var userName: String?
    var userDescription: String?
    var userPhoto: UIImage?
    var savedFields: [String:Bool] = ["name": false,
                                      "description": false,
                                      "photo": false]
    var fails = [String]()
    
    init(name: String?, description: String?, photo: UIImage?) {
        self.userName = name
        self.userDescription = description
        self.userPhoto = photo
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        //добавил sleep для наглядности ожидания
        sleep(2)
        
        if isCancelled {
            return
        }
        
        saveData()
    }
    
    
    func saveData() {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        if let name = userName {
            do {
                try name.write(to: directory.appendingPathComponent(self.nameFilename), atomically: true, encoding: .utf8)
                savedFields["name"] = true
                print("saved name")
            } catch {
                fails.append("name")
                print(error.localizedDescription)
            }
        }
        
        if let description = userDescription {
            do {
                try description.write(to: directory.appendingPathComponent(self.descriptionFilename), atomically: true, encoding: .utf8)
                savedFields["description"] = true
                print("saved description")
            } catch {
                fails.append("description")
                print(error.localizedDescription)
            }
        }
        
        if let photo = userPhoto,
           let photoData = photo.pngData() {
            do {
                try photoData.write(to: directory.appendingPathComponent(self.photoFilename))
                savedFields["photo"] = true
                print("saved photo")
            } catch {
                fails.append("photo")
                print(error.localizedDescription)
            }
        }
    }
}
