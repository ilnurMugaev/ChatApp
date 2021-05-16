//
//  ChatAppUITests.swift
//  ChatAppUITests
//
//  Created by Ilnur Mugaev on 01.05.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import XCTest

class ChatAppUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testTextFieldsExits() throws {

        let app = XCUIApplication()
        app.launch()

        app.navigationBars["Tinkoff Chat"].buttons["profileButton"].tap()

        let textField = app.textFields.element(boundBy: 0)
        let textView = app.textViews.element(boundBy: 0)
        _ = textField.waitForExistence(timeout: 5.0)
        _ = textView.waitForExistence(timeout: 5.0)

        XCTAssertTrue(textField.exists)
        XCTAssertTrue(textView.exists)
    }
}
