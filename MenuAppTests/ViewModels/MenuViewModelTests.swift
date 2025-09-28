//
//  MenuViewModelTests.swift
//  MenuAppTests
//
//  Created by Raju Dhumne on 25/09/25.
//

import XCTest
@testable import MenuApp

@MainActor
final class MenuViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var viewModel: MenuViewModelImpl!
    private var mockRepository: MockMenuRepository!
    private var mockDelegate: MockMenuViewModelDelegate!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockRepository = MockMenuRepository()
        mockDelegate = MockMenuViewModelDelegate()
        viewModel = MenuViewModelImpl(menuRepository: mockRepository)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testLoadMenuSuccess() async throws {
        // Given
        let expectedItems = [
            MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer"),
            MenuItem(id: 2, name: "Grilled Chicken", price: 18.99, category: "main"),
            MenuItem(id: 3, name: "Chocolate Cake", price: 8.99, category: "dessert")
        ]
        
        mockRepository.mockMenuItems = expectedItems
        
        // When
        try await viewModel.loadMenu()
        
        // Then
        XCTAssertTrue(mockDelegate.didUpdateItemsCalled)
        XCTAssertEqual(mockDelegate.lastUpdatedItems?.count, 3)
        XCTAssertEqual(mockDelegate.lastUpdatedItems?["appetizer"]?.count, 1)
        XCTAssertEqual(mockDelegate.lastUpdatedItems?["main"]?.count, 1)
        XCTAssertEqual(mockDelegate.lastUpdatedItems?["dessert"]?.count, 1)
    }
    
    func testLoadMenuFailure() async throws {
        // Given
        mockRepository.shouldThrowError = true
        mockRepository.mockError = NetworkError.httpError(500)
        
        // When
        try await viewModel.loadMenu()
        
        // Then
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
        XCTAssertTrue(mockDelegate.lastError is NetworkError)
    }
    
    func testSelectItemSuccess() async throws {
        // Given
        let expectedDetail = MenuItemDetail(
            id: 1,
            name: "Caesar Salad",
            price: 12.99,
            category: "appetizer",
            description: "Fresh romaine lettuce",
            image: "https://example.com/image.jpg"
        )
        
        mockRepository.mockMenuItemDetail = expectedDetail
        
        // When
        try await viewModel.selectItem(at: 1)
        
        // Then
        XCTAssertTrue(mockDelegate.didSelectItemCalled)
        XCTAssertEqual(mockDelegate.lastSelectedItem?.id, 1)
        XCTAssertEqual(mockDelegate.lastSelectedItem?.name, "Caesar Salad")
    }
    
    func testSelectItemFailure() async throws {
        // Given
        mockRepository.shouldThrowError = true
        mockRepository.mockError = NetworkError.httpError(404)
        
        // When
        try await viewModel.selectItem(at: 999)
        
        // Then
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
        XCTAssertTrue(mockDelegate.lastError is NetworkError)
    }
    
    func testDataGrouping() async throws {
        // Given
        let items = [
            MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer"),
            MenuItem(id: 2, name: "Soup", price: 8.99, category: "appetizer"),
            MenuItem(id: 3, name: "Grilled Chicken", price: 18.99, category: "main")
        ]
        
        mockRepository.mockMenuItems = items
        
        // When
        try await viewModel.loadMenu()
        
        // Then
        XCTAssertTrue(mockDelegate.didUpdateItemsCalled)
        XCTAssertEqual(mockDelegate.lastUpdatedItems?["appetizer"]?.count, 2)
        XCTAssertEqual(mockDelegate.lastUpdatedItems?["main"]?.count, 1)
        XCTAssertNil(mockDelegate.lastUpdatedItems?["dessert"])
    }
}

// MARK: - Mock Menu Repository
class MockMenuRepository: MenuRepositoryProtocol {
    var mockMenuItems: [MenuItem] = []
    var mockMenuItemDetail: MenuItemDetail?
    var shouldThrowError = false
    var mockError: Error?
    
    func getMenu() async throws -> [MenuItem] {
        if shouldThrowError {
            throw mockError ?? NetworkError.invalidResponse
        }
        return mockMenuItems
    }
    
    func getMenuItemDetail(id: Int) async throws -> MenuItemDetail {
        if shouldThrowError {
            throw mockError ?? NetworkError.invalidResponse
        }
        guard let detail = mockMenuItemDetail else {
            throw NetworkError.invalidResponse
        }
        return detail
    }
}

// MARK: - Mock Menu ViewModel Delegate
class MockMenuViewModelDelegate: MenuViewModelDelegateProtocol {
    var didUpdateItemsCalled = false
    var didSelectItemCalled = false
    var didFailWithErrorCalled = false
    
    var lastUpdatedItems: [String: [MenuItem]]?
    var lastSelectedItem: MenuItemDetail?
    var lastError: Error?
    
    func didUpdateavailableItems(data: [String: [MenuItem]]) {
        didUpdateItemsCalled = true
        lastUpdatedItems = data
    }
    
    func didSelectItem(_ item: MenuItemDetail) {
        didSelectItemCalled = true
        lastSelectedItem = item
    }
    
    func didFailWithError(_ error: any Error) {
        didFailWithErrorCalled = true
        lastError = error
    }
}




