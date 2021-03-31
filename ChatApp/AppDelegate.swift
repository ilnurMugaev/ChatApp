//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 14.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let logging = Logging.shared
    
    var loggingEnabled = true
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
        
    // Приложение полностью загрузилось.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logging.loggingEnabled = loggingEnabled
        logging.printLog()        
        ThemeManager.loadTheme()
        return true
    }
    
    // Приложение собирается стать неактивным.
    func applicationWillResignActive(_ application: UIApplication) {
        logging.printLog()
    }
    
    // Приложение вошло в фоновый режим.
    func applicationDidEnterBackground(_ application: UIApplication) {
        logging.printLog()
    }
    
    // Приложение собирается вернуться на передний план.
    func applicationWillEnterForeground(_ application: UIApplication) {
        logging.printLog()
    }
    
    // Приложение активно и готово для работы.
    func applicationDidBecomeActive(_ application: UIApplication) {
        logging.printLog()
    }
    
    // Приложение завершило работу.
    func applicationWillTerminate(_ application: UIApplication) {
        logging.printLog()
    }
    
    func changeStatusBar(theme: Theme) {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = theme.colors.userInterfaceStyle
        }
    }
}
