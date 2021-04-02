//
//  GCDDataManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 18.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

protocol SaveDataManager {
    func saveData(name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void)
    func loadData(completion: @escaping (String?, String?, UIImage?) -> Void)
}

class GCDDataManager: SaveDataManager {
    private let nameFilename = Constants.nameFileName
    private let descriptionFilename = Constants.descriptionFileName
    private let photoFilename = Constants.photoFileName
    private let themeFilename = Constants.themeFileName
    
    func saveData(name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void) {
        print("saving with GCD")
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        var savedFields: [String: Bool] = ["name": false,
                                          "description": false,
                                          "photo": false]
        var fails = [String]()
        
        let queue = DispatchQueue.global()
        queue.async {
            // добавил sleep для наглядности ожидания
            sleep(2)
            if let name = name {
                do {
                    try name.write(to: directory.appendingPathComponent(self.nameFilename), atomically: true, encoding: .utf8)
                    savedFields["name"] = true
                    Constants.senderName = name
                    print("saved name")
                } catch {
                    fails.append("name")
                    print(error.localizedDescription)
                }
            }
            
            if let description = description {
                do {
                    try description.write(to: directory.appendingPathComponent(self.descriptionFilename), atomically: true, encoding: .utf8)
                    savedFields["description"] = true
                    print("saved description")
                } catch {
                    fails.append("description")
                    print(error.localizedDescription)
                }
            }
            
            if let photo = photo,
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
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let queue = DispatchQueue.global()
        queue.async {
            do {
                name = try String(contentsOf: directory.appendingPathComponent(self.nameFilename))
            } catch {
                print(error.localizedDescription)
            }
            
            do {
                description = try String(contentsOf: directory.appendingPathComponent(self.descriptionFilename))
            } catch {
                print(error.localizedDescription)
            }
            
            do {
                let photoData = try Data(contentsOf: directory.appendingPathComponent(self.photoFilename))
                photo = UIImage(data: photoData)
            } catch {
                print(error.localizedDescription)
            }

            completion(name, description, photo)
        }
    }
    
    func saveTheme(themeNo: String) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let queue = DispatchQueue.global()
        queue.async {
            do {
                try themeNo.write(to: directory.appendingPathComponent(self.themeFilename), atomically: true, encoding: .utf8)
                print("saved theme")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadTheme(completion: @escaping (Theme?) -> Void) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil)
            return
        }
        
        let queue = DispatchQueue.global()
        queue.async {
            do {
                let themeNoString = try String(contentsOf: directory.appendingPathComponent(self.themeFilename))
                let themeNo = Int(themeNoString) ?? 0
                let theme = Theme(rawValue: themeNo)
                print("loaded theme")
                completion(theme)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
