//
//  Logging.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 14.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

final class Logging {
        
    static let shared = Logging()
    
    /// Logging state.
    var loggingEnabled = true
    
    /// Previous application state.
    private var previousState = "NOT RUNNING"
    
    /// Current application state.
    private var currentState = ""
    
    private var property = ""

    private init() {}
    
    private init(property: String) {
        self.property = property
    }
    
    /// Print logs to the console:
    /// - Parameter function: function name.
    func printLog(function: String = #function, property: String = "") {
        
        guard loggingEnabled else { return }
        
        switch UIApplication.shared.applicationState {
        case .active:
            currentState = "ACTIVE"
        case .inactive:
            currentState = "INACTIVE"
        case .background:
            currentState = "BACKGROUND"
        default:
            break
        }
        
        let propertyString = property == "" ? "" : "; property: \(property)"
        
        if currentState != previousState {
            print("Application moved from \(previousState) to \(currentState): \(function)" + propertyString)
        } else {
            print("Application state is \(currentState): \(function)" + propertyString)
        }
                
        previousState = currentState
    }
}
