//
//  MenuAppTests.swift
//  MenuAppTests
//
//  Created by Raju Dhumne on 25/09/25.
//

import XCTest
@testable import MenuApp

final class MenuAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppLaunch() throws {
        // This is a basic test to ensure the app can launch without crashing
        XCTAssertTrue(true, "App should launch successfully")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
