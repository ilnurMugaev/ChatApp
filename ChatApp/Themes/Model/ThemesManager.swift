//
//  ThemesManager.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 10.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

enum Theme: Int, CaseIterable {
    case classic, day, night
    
    var colors: ColorsModel {
        switch self {
        case .classic:
            return ColorsDataManager.classicTheme
        case .day:
            return ColorsDataManager.dayTheme
        case .night:
            return ColorsDataManager.nightTheme
        }
    }
}

let themeKey = "selectedTheme"

struct ThemesManager {
    
    static var currentTheme = Theme.classic
    
    static func loadTheme() {
        GCDDataManager().loadTheme { (theme) in
            if let storedTheme = theme {
                self.currentTheme = storedTheme
            } else {
                self.currentTheme = .classic
            }
            
            DispatchQueue.main.async {
                applyTheme(theme: currentTheme)
                updateWindows()
            }
        }
    }
    
    static func saveTheme(theme: Theme) {
        let themeNo = String(theme.rawValue)
        GCDDataManager().saveTheme(themeNo: themeNo)
        currentTheme = theme
    }
    
    static func applyTheme(theme: Theme) {
        let proxyNavigationBar = UINavigationBar.appearance()
        proxyNavigationBar.tintColor = theme.colors.tintColor
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.colors.UIElementColor
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.mainFontColor]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.mainFontColor]
            
            proxyNavigationBar.standardAppearance = appearance
            proxyNavigationBar.scrollEdgeAppearance = appearance
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.changeStatusBar(theme: theme)
            }
        } else {
            proxyNavigationBar.barTintColor = theme.colors.UIElementColor
            proxyNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.mainFontColor]
            proxyNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.mainFontColor]
            proxyNavigationBar.barStyle = theme.colors.barStyle
        }
        
        let proxyTableView = UITableView.appearance()
        proxyTableView.backgroundColor = theme.colors.backgroundColor
    }
    
    static func updateWindows() {
        let windows = UIApplication.shared.windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}
