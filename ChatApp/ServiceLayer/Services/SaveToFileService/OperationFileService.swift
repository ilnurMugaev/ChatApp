//
//  OperationDataManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 18.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class OperationFileService: SaveDataToFileServiceProtocol {
    let saveToFileManager: SaveToFileManagerProtocol
    
    init(saveToFileManager: SaveToFileManagerProtocol) {
        self.saveToFileManager = saveToFileManager
    }
    
    func saveData(name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void) {
        print("saving with Operation")
        let saveOperation = SaveOperation(saveToFileManager: saveToFileManager, name: name, description: description, photo: photo)
        
        saveOperation.completionBlock = {
            DispatchQueue.main.async {
                completion(saveOperation.savedFields, saveOperation.fails)
            }
        }
        OperationQueue().addOperation(saveOperation)
    }
    
    func loadData(completion: @escaping (String?, String?, UIImage?) -> Void) {
        print("loading with Operation")
        let loadOperation = LoadOperation(saveToFileManager: saveToFileManager)
        
        loadOperation.completionBlock = {
            DispatchQueue.main.async {
                completion(loadOperation.userName, loadOperation.userDescription, loadOperation.userPhoto)
            }
        }
        OperationQueue().addOperation(loadOperation)
    }
}
