//
//  ThemesModel.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 15.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import Foundation

protocol ThemesProtocol {
    func currentTheme() -> Theme
    func setTheme(theme: Theme)
}

extension ThemesProtocol {
    func setTheme(theme: Theme) { }
}

protocol ThemesModelProtocol: ThemesProtocol {
    func saveTheme(theme: Theme)
}

class ThemesModel: ThemesModelProtocol {
    private let themeService: ThemeServiceProtocol
    
    init(themeService: ThemeServiceProtocol) {
        self.themeService = themeService
    }
    
    func currentTheme() -> Theme {
        return themeService.currentTheme
    }
    
    func saveTheme(theme: Theme) {
        themeService.saveTheme(theme: theme)
    }
}
