//
//  GCDFileService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 18.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol SaveDataToFileServiceProtocol {
    func saveData(name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void)
    func loadData(completion: @escaping (String?, String?, UIImage?) -> Void)
}

protocol SaveThemeToFileServiceProtocol {
    func saveTheme(themeNo: String)
    func loadTheme(completion: @escaping (Theme?) -> Void)
}

class GCDFileService: SaveDataToFileServiceProtocol, SaveThemeToFileServiceProtocol {
    let saveToFileManager: SaveToFileManagerProtocol
    
    init(saveToFileManager: SaveToFileManagerProtocol) {
        self.saveToFileManager = saveToFileManager
    }
    
    private let nameFilename = Constants.nameFileName
    private let descriptionFilename = Constants.descriptionFileName
    private let photoFilename = Constants.photoFileName
    private let themeFilename = Constants.themeFileName
    
    func saveData(name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void) {
        print("saving with GCD")
        
        var savedFields: [String: Bool] = ["name": false,
                                          "description": false,
                                          "photo": false]
        var fails = [String]()
        
        let queue = DispatchQueue.global()
        queue.async {
            // добавил sleep для наглядности ожидания
            sleep(2)
            
            if let name = name {
                if self.saveToFileManager.saveString(to: self.nameFilename, string: name) {
                    savedFields["name"] = true
                    Constants.senderName = name
                    print("saved name")
                } else {
                    fails.append("name")
                }
            }
            
            if let description = description {
                if self.saveToFileManager.saveString(to: self.descriptionFilename, string: description) {
                    savedFields["description"] = true
                    print("saved description")
                } else {
                    fails.append("description")
                }
            }
            
            if let photo = photo,
                let photoData = photo.pngData() {
                if self.saveToFileManager.saveData(to: self.photoFilename, data: photoData) {
                    savedFields["photo"] = true
                    print("saved photo")
                } else {
                    fails.append("photo")
                }
            }
            
            DispatchQueue.main.async {
                completion(savedFields, fails)
            }
        }
    }
    
    func loadData(completion: @escaping (String?, String?, UIImage?) -> Void) {
        print("loading with GCD")
        var name: String?
        var description: String?
        var photo: UIImage?
                
        let queue = DispatchQueue.global()
        queue.async {
            name = self.saveToFileManager.loadString(from: self.nameFilename)
            description = self.saveToFileManager.loadString(from: self.descriptionFilename)
            if let photoData = self.saveToFileManager.loadData(from: self.photoFilename) {
                photo = UIImage(data: photoData)
            }

            completion(name, description, photo)
        }
    }
    
    func saveTheme(themeNo: String) {
        let queue = DispatchQueue.global()
        queue.async {
            if self.saveToFileManager.saveString(to: self.themeFilename, string: themeNo) {
                print("saved theme")
            }
        }
    }
    
    func loadTheme(completion: @escaping (Theme?) -> Void) {
        print("loading theme")

        let queue = DispatchQueue.global()
        queue.async {
            if let themeNoString = self.saveToFileManager.loadString(from: self.themeFilename) {
                let themeNo = Int(themeNoString) ?? 0
                let theme = Theme(rawValue: themeNo)
                completion(theme)
            } else {
                completion(nil)
            }
        }
    }
}
