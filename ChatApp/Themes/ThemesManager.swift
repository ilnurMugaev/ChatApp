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
            return Constants.classicTheme
        case .day:
            return Constants.dayTheme
        case .night:
            return Constants.nightTheme
        }
    }
}

let themeKey = "selectedTheme"

struct ThemesManager {
    static var currentTheme = selectedTheme()
    
    static func selectedTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: themeKey) as? Int {
            guard let theme = Theme(rawValue: storedTheme) else { return .classic}
            return theme
        } else {
            return .classic
        }
    }
    
    static func saveTheme(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        UserDefaults.standard.synchronize()
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
