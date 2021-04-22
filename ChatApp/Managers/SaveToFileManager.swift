//
//  SaveToFileManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol SaveToFileManagerProtocol {
    func saveString(to file: String, string: String) -> Bool
    func saveData(to file: String, data: Data) -> Bool
    func loadString(from file: String) -> String?
    func loadData(from file: String) -> Data?
}

class SaveToFileManager: SaveToFileManagerProtocol {
    func saveString(to file: String, string: String) -> Bool {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        
        do {
            try string.write(to: directory.appendingPathComponent(file), atomically: true, encoding: .utf8)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func saveData(to file: String, data: Data) -> Bool {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        
        do {
            try data.write(to: directory.appendingPathComponent(file))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func loadString(from file: String) -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        do {
            let string = try String(contentsOf: directory.appendingPathComponent(file))
            return string
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadData(from file: String) -> Data? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        do {
            let data = try Data(contentsOf: directory.appendingPathComponent(file))
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
