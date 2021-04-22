//
//  ThemeService.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 10.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

enum Theme: Int, CaseIterable {
    case classic, day, night
    
    var colors: Colors {
        switch self {
        case .classic:
            return Constants.classicTheme
        case .day:
            return Constants.dayTheme
        case .night:
            return Constants.nightTheme
        }
    }
}

let themeKey = "selectedTheme"

protocol ThemeServiceProtocol {
    var currentTheme: Theme { get set }
    func loadTheme()
    func saveTheme(theme: Theme)
    func applyTheme(theme: Theme)
    func updateWindows()
}

class ThemeService: ThemeServiceProtocol {
    let gcdFileService: SaveThemeToFileServiceProtocol
    var currentTheme = Theme.classic
    
    init(gcdFileService: SaveThemeToFileServiceProtocol) {
        self.gcdFileService = gcdFileService
        self.loadTheme()
    }
    
    func loadTheme() {
        gcdFileService.loadTheme { (theme) in
            if let storedTheme = theme {
                self.currentTheme = storedTheme
            } else {
                self.currentTheme = .classic
            }
            
            DispatchQueue.main.async {
                self.applyTheme(theme: self.currentTheme)
                self.updateWindows()
            }
        }
    }
    
    func saveTheme(theme: Theme) {
        let themeNo = String(theme.rawValue)
        gcdFileService.saveTheme(themeNo: themeNo)
        currentTheme = theme
    }
    
    func applyTheme(theme: Theme) {
        let proxyNavigationBar = UINavigationBar.appearance()
        proxyNavigationBar.tintColor = theme.colors.tintColor
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.colors.UIElementColor
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.colors.baseFontColor]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.colors.baseFontColor]
            
            proxyNavigationBar.standardAppearance = appearance
            proxyNavigationBar.scrollEdgeAppearance = appearance
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.changeStatusBar(theme: theme)
            }
        } else {
            proxyNavigationBar.barTintColor = theme.colors.UIElementColor
            proxyNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.colors.baseFontColor]
            proxyNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.colors.baseFontColor]
            proxyNavigationBar.barStyle = theme.colors.barStyle
        }
        
        let proxyTableView = UITableView.appearance()
        proxyTableView.backgroundColor = theme.colors.backgroundColor
    }
    
    func updateWindows() {
        let windows = UIApplication.shared.windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}
