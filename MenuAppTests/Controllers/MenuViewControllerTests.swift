//
//  MenuViewControllerTests.swift
//  MenuAppTests
//
//  Created by Raju Dhumne on 25/09/25.
//

import XCTest
@testable import MenuApp

final class MenuViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    private var viewController: MenuViewController!
    private var mockViewModel: MockMenuViewModel!
    private var mockDataSource: MockTableViewDataSource!
    private var mockErrorHandler: MockErrorHandler!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockViewModel = MockMenuViewModel()
        mockDataSource = MockTableViewDataSource()
        mockErrorHandler = MockErrorHandler()
        
        // Create view controller with mocked dependencies
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(identifier: "MenuViewController") { coder in
            MenuViewController(
                coder: coder,
                viewModel: self.mockViewModel,
                dataSource: self.mockDataSource,
                errorHandler: self.mockErrorHandler
            )
        }
        
        // Load view but don't call viewDidLoad yet
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        // Reset mock state
        mockViewModel?.reset()
        
        viewController = nil
        mockViewModel = nil
        mockDataSource = nil
        mockErrorHandler = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitializationWithDependencies() {
        // Then
        XCTAssertNotNil(viewController)
        
    }
    
    func testViewDidLoadCallsLoadMenu() {
        // Given
        let expectation = expectation(description: "loadMenu called")
        expectation.expectedFulfillmentCount = 1
        mockViewModel.loadMenuExpectation = expectation
        
        // When
        viewController.viewDidLoad()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(mockViewModel.loadMenuCalled)
    }
    
    func testDataSourceIsSet() {
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewController.tableView.dataSource === mockDataSource)
    }
    
    func testDelegateIsSet() {
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewController.tableView.delegate === viewController)
    }
}

// MARK: - Mock Menu ViewModel
class MockMenuViewModel: MenuViewModelProtocol {
    var delegate: MenuViewModelDelegateProtocol?
    var loadMenuCalled = false
    var selectItemCalled = false
    var loadMenuExpectation: XCTestExpectation?
    private var loadMenuCallCount = 0
    
    func loadMenu() async throws {
        loadMenuCalled = true
        loadMenuCallCount += 1
        
        // Only fulfill expectation once
        if loadMenuCallCount == 1 {
            loadMenuExpectation?.fulfill()
        }
    }
    
    func selectItem(at index: Int) async throws {
        selectItemCalled = true
    }
    
    func reset() {
        loadMenuCalled = false
        selectItemCalled = false
        loadMenuCallCount = 0
        loadMenuExpectation = nil
    }
}

// MARK: - Mock Table View Data Source
class MockTableViewDataSource: NSObject, MenuViewDataSourceProtocol {
    var updateDataCalled = false
    var lastUpdatedData: [String: [MenuItem]]?
    
    func updateData(_ menuItems: [String: [MenuItem]]) {
        updateDataCalled = true
        lastUpdatedData = menuItems
    }
    
    func getItem(at indexPath: IndexPath) -> MenuItem? {
        return MenuItem(id: 1, name: "Test Item", price: 10.99, category: "test")
    }
    
    func getCategory(at section: Int) -> String? {
        return "test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - Mock Error Handler
class MockErrorHandler: ErrorHandlerProtocol {
    var handleErrorCalled = false
    var lastError: Error?
    var lastViewController: UIViewController?
    
    func handle(_ error: Error, in viewController: UIViewController) {
        handleErrorCalled = true
        lastError = error
        lastViewController = viewController
    }
    
    func mapNetworkError(_ error: Error) -> MenuError {
        return .unknown(error)
    }
}

