//
//  SaveToFileManagerMock.swift
//  ChatAppTests
//
//  Created by Ilnur Mugaev on 01.05.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

@testable import ChatApp
import Foundation

class SaveToFileManagerMock: SaveToFileManagerProtocol {
    var savedString = ""
    var savedData = Data()

    func saveString(to file: String, string: String) -> Bool {
        savedString = string
        return true
    }

    func saveData(to file: String, data: Data) -> Bool {
        savedData = data
        return true
    }

    func loadString(from file: String) -> String? {
        return nil
    }

    func loadData(from file: String) -> Data? {
        return nil
    }
}
