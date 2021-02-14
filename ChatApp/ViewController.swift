//
//  ViewController.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 14.02.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let logging = Logging.shared
    
    // Срабатывает после загрузки view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logging.printLog()
    }
    
    // Срабатывает перед появлением view на экране.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logging.printLog()
    }
        
    // Срабатывает после появлением view на экране.
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logging.printLog()
    }
    
    // Срабатывает перед тем, как размер view изменится под размер экрана.
    override func viewWillLayoutSubviews() {
        logging.printLog()
    }
    
    // Срабатывает после того, как размер view изменился под размер экрана.
    override func viewDidLayoutSubviews() {
        logging.printLog()
    }
        
    // Сработает перед тем, как view закроется.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logging.printLog()
    }
    
    // Сработает после того, как view закрылся.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logging.printLog()
    }
}

