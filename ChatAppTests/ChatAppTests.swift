//
//  ChatAppTests.swift
//  ChatAppTests
//
//  Created by Ilnur Mugaev on 01.05.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

@testable import ChatApp
import XCTest

class ChatAppTests: XCTestCase {

    func testGCDFileServiceCallsSaveToFileManager() {

        // given
        let testName = "test name"
        let testPhoto = UIImage(named: "icon_send")
        let saveToFileManagerMock = SaveToFileManagerMock()
        let savePhotoExpectation = expectation(description: "Save photo expectation")

        // when
        let gcdFileServiceMock = GCDFileService(saveToFileManager: saveToFileManagerMock)
        gcdFileServiceMock.saveData(name: testName, description: nil, photo: testPhoto) { (_, _) in
            savePhotoExpectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 5) { _ in
            XCTAssertEqual("test name", testName)
            XCTAssertEqual(saveToFileManagerMock.savedData, testPhoto?.pngData())
        }
    }

    func testRequestManagerGetsValidURL() {

        // given
        let baseUrl = "https://pixabay.com"
        let path = "/api/?key=19099745-2e27ab96f19dd46a70f143587&q=funny+cat&image_type=photo&per_page=100"

        let requestManagerMock = RequestManagerMock()
        requestManagerMock.completionStub = { completion in
            completion(.success(Data()))
        }

        // when
        let allPhotosService = AllPhotosService(requestManager: requestManagerMock)
        allPhotosService.getAllPhotos(searchText: Constants.searchText) { (_, _) in
        }

        // then
        XCTAssertEqual(baseUrl + path, requestManagerMock.receivedUrl)
    }

    func testDataIsCashed() {

        // given
        let searchText = Constants.searchText
        let urlRequest = AllPhotosRequest(searchText: searchText).urlRequest!
        let requestManager = RequestManager(urlSession: URLSession.shared)
        let cacheDataExpectation = expectation(description: "Data was cached expectation")
        var receivedData: Data?

        // when
        let allPhotosService = AllPhotosServiceMock(requestManager: requestManager)
        allPhotosService.getAllPhotos(searchText: searchText) { (_, _) in
            receivedData = allPhotosService.receivedData
            cacheDataExpectation.fulfill()
        }

        // then
        waitForExpectations(timeout: 5) { _ in
            let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest)
            XCTAssertNotNil(cachedResponse)
            XCTAssertEqual(cachedResponse?.data, receivedData)
        }
    }
}
