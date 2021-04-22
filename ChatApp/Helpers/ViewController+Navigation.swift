//
//  ViewController+Navigation.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 16.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        let nc = UINavigationController()
        nc.viewControllers = [self]
        return nc
    }
}
