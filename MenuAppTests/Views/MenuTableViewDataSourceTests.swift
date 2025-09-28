//
//  MenuTableViewDataSourceTests.swift
//  MenuAppTests
//
//  Created by Raju Dhumne on 25/09/25.
//

import XCTest
@testable import MenuApp

final class MenuTableViewDataSourceTests: XCTestCase {
    
    // MARK: - Properties
    private var dataSource: MenuTableViewDataSource!
    private var mockTableView: MockTableView!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        dataSource = MenuTableViewDataSource()
        mockTableView = MockTableView()
    }
    
    override func tearDown() {
        dataSource = nil
        mockTableView = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testNumberOfSections() {
        // Given
        let menuItems = [
            "appetizer": [MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer")],
            "main": [MenuItem(id: 2, name: "Grilled Chicken", price: 18.99, category: "main")],
            "dessert": [MenuItem(id: 3, name: "Chocolate Cake", price: 8.99, category: "dessert")]
        ]
        dataSource.updateData(menuItems)
        
        // When
        let numberOfSections = dataSource.numberOfSections(in: mockTableView)
        
        // Then
        XCTAssertEqual(numberOfSections, 3)
    }
    
    func testNumberOfRowsInSection() {
        // Given
        let menuItems = [
            "appetizer": [
                MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer"),
                MenuItem(id: 2, name: "Soup", price: 8.99, category: "appetizer")
            ],
            "main": [MenuItem(id: 3, name: "Grilled Chicken", price: 18.99, category: "main")]
        ]
        dataSource.updateData(menuItems)
        
        // When
        let appetizerRows = dataSource.tableView(mockTableView, numberOfRowsInSection: 0) // appetizer
        let mainRows = dataSource.tableView(mockTableView, numberOfRowsInSection: 1) // main
        let dessertRows = dataSource.tableView(mockTableView, numberOfRowsInSection: 2) // dessert (empty)
        
        // Then
        XCTAssertEqual(appetizerRows, 2)
        XCTAssertEqual(mainRows, 1)
        XCTAssertEqual(dessertRows, 0)
    }
    
    func testGetItem() {
        // Given
        let menuItems = [
            "appetizer": [
                MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer"),
                MenuItem(id: 2, name: "Soup", price: 8.99, category: "appetizer")
            ],
            "main": [MenuItem(id: 3, name: "Grilled Chicken", price: 18.99, category: "main")]
        ]
        dataSource.updateData(menuItems)
        
        // When
        let firstItem = dataSource.getItem(at: IndexPath(row: 0, section: 0))
        let secondItem = dataSource.getItem(at: IndexPath(row: 1, section: 0))
        let mainItem = dataSource.getItem(at: IndexPath(row: 0, section: 1))
        let invalidItem = dataSource.getItem(at: IndexPath(row: 0, section: 2))
        
        // Then
        XCTAssertEqual(firstItem?.name, "Caesar Salad")
        XCTAssertEqual(secondItem?.name, "Soup")
        XCTAssertEqual(mainItem?.name, "Grilled Chicken")
        XCTAssertNil(invalidItem)
    }
    
    func testGetCategory() {
        // Given
        let menuItems = [
            "appetizer": [MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer")],
            "main": [MenuItem(id: 2, name: "Grilled Chicken", price: 18.99, category: "main")]
        ]
        dataSource.updateData(menuItems)
        
        // When
        let appetizerCategory = dataSource.getCategory(at: 0)
        let mainCategory = dataSource.getCategory(at: 1)
        let invalidCategory = dataSource.getCategory(at: 2)
        
        // Then
        XCTAssertEqual(appetizerCategory, "appetizer")
        XCTAssertEqual(mainCategory, "main")
        XCTAssertNil(invalidCategory)
    }
    
    func testUpdateData() {
        // Given
        let initialMenuItems = [
            "appetizer": [MenuItem(id: 1, name: "Caesar Salad", price: 12.99, category: "appetizer")]
        ]
        dataSource.updateData(initialMenuItems)
        
        // When
        let newMenuItems = [
            "main": [MenuItem(id: 2, name: "Grilled Chicken", price: 18.99, category: "main")],
            "dessert": [MenuItem(id: 3, name: "Chocolate Cake", price: 8.99, category: "dessert")]
        ]
        dataSource.updateData(newMenuItems)
        
        // Then
        XCTAssertEqual(dataSource.numberOfSections(in: mockTableView), 2)
        XCTAssertEqual(dataSource.getCategory(at: 0), "dessert") // Sorted alphabetically
        XCTAssertEqual(dataSource.getCategory(at: 1), "main")
        XCTAssertNil(dataSource.getCategory(at: 2))
    }
    
    func testEmptyData() {
        // Given
        let emptyMenuItems: [String: [MenuItem]] = [:]
        dataSource.updateData(emptyMenuItems)
        
        // When
        let numberOfSections = dataSource.numberOfSections(in: mockTableView)
        let numberOfRows = dataSource.tableView(mockTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfSections, 0)
        XCTAssertEqual(numberOfRows, 0)
    }
}

// MARK: - Mock Table View
class MockTableView: UITableView {
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}




