//
//  MenuRepositoryTests.swift
//  MenuAppTests
//
//  Created by Raju Dhumne on 25/09/25.
//

import XCTest
@testable import MenuApp

final class MenuRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    private var repository: MenuRepository!
    private var mockNetworkManager: MockNetworkManager!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        repository = MenuRepository(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        repository = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testGetMenuSuccess() async throws {
        // Given
        let expectedMenuItems = [
            MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer"),
            MenuItem(id: 2, name: "Grilled Chicken", price: 18.99, category: "main")
        ]
        
        mockNetworkManager.mockMenuItems = expectedMenuItems
        
        // When
        let result = try await repository.getMenu()
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "Caesar Salad")
        XCTAssertEqual(result[1].name, "Grilled Chicken")
    }
    
    func testGetMenuFailure() async {
        // Given
        mockNetworkManager.shouldThrowError = true
        mockNetworkManager.mockError = NetworkError.httpError(500)
        
        // When & Then
        do {
            let _ = try await repository.getMenu()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testGetMenuItemDetailSuccess() async throws {
        // Given
        let expectedDetail = MenuItemDetail(
            id: 1,
            name: "Caesar Salad",
            price: 12.99,
            category: "appetizer",
            description: "Fresh romaine lettuce",
            image: "https://example.com/image.jpg"
        )
        
        mockNetworkManager.mockMenuItemDetail = expectedDetail
        
        // When
        let result = try await repository.getMenuItemDetail(id: 1)
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "Caesar Salad")
        XCTAssertEqual(result.description, "Fresh romaine lettuce")
    }
    
    func testGetMenuItemDetailFailure() async {
        // Given
        mockNetworkManager.shouldThrowError = true
        mockNetworkManager.mockError = NetworkError.httpError(404)
        
        // When & Then
        do {
            let _ = try await repository.getMenuItemDetail(id: 999)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}

// MARK: - Mock Network Manager
class MockNetworkManager: NetworkManagerProtocol {
    var mockMenuItems: [MenuItem] = []
    var mockMenuItemDetail: MenuItemDetail?
    var shouldThrowError = false
    var mockError: Error?
    
    func execute<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        if shouldThrowError {
            throw mockError ?? NetworkError.invalidResponse
        }
        
        if responseType == [MenuItem].self {
            return mockMenuItems as! T
        } else if responseType == MenuItemDetail.self {
            return mockMenuItemDetail as! T
        }
        
        throw NetworkError.invalidResponse
    }
}


