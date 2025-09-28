//
//  MenuRouterTests.swift
//  MenuAppTests
//
//  Created by Raju Dhumne on 25/09/25.
//

import XCTest
@testable import MenuApp

final class MenuRouterTests: XCTestCase {
    
    // MARK: - Tests
    
    func testMenuRouterMethod() {
        // Given
        let menuRouter = MenuRouter.menu
        let menuItemDetailRouter = MenuRouter.menuItemDetail(id: 123)
        
        // When & Then
        XCTAssertEqual(menuRouter.method, .GET)
        XCTAssertEqual(menuItemDetailRouter.method, .GET)
    }
    
    func testMenuRouterPath() {
        // Given
        let menuRouter = MenuRouter.menu
        let menuItemDetailRouter = MenuRouter.menuItemDetail(id: 123)
        
        // When & Then
        XCTAssertEqual(menuRouter.path, "/menu")
        XCTAssertEqual(menuItemDetailRouter.path, "/menu/123")
    }
    
    func testMenuRouterURL() {
        // Given
        let menuRouter = MenuRouter.menu
        let menuItemDetailRouter = MenuRouter.menuItemDetail(id: 123)
        
        // When
        let menuURL = menuRouter.url
        let menuItemDetailURL = menuItemDetailRouter.url
        
        // Then
        XCTAssertNotNil(menuURL)
        XCTAssertNotNil(menuItemDetailURL)
    }
    
    func testMenuRouterURLRequest() {
        // Given
        let menuRouter = MenuRouter.menu
        let menuItemDetailRouter = MenuRouter.menuItemDetail(id: 123)
        
        // When
        let menuRequest = menuRouter.urlRequest
        let menuItemDetailRequest = menuItemDetailRouter.urlRequest
        
        // Then
        XCTAssertNotNil(menuRequest)
        XCTAssertNotNil(menuItemDetailRequest)
        
        XCTAssertEqual(menuRequest?.httpMethod, "GET")
        XCTAssertEqual(menuItemDetailRequest?.httpMethod, "GET")
        
       
        XCTAssertEqual(menuRequest?.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(menuRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(menuItemDetailRequest?.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(menuItemDetailRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func testMenuRouterWithDifferentIDs() {
        // Given
        let router1 = MenuRouter.menuItemDetail(id: 1)
        let router2 = MenuRouter.menuItemDetail(id: 999)
        let router3 = MenuRouter.menuItemDetail(id: 0)
        
        // When & Then
        XCTAssertEqual(router1.path, "/menu/1")
        XCTAssertEqual(router2.path, "/menu/999")
        XCTAssertEqual(router3.path, "/menu/0")
    }
}




