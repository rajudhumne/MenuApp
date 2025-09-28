//
//  NetworkManagerTests.swift
//  MenuAppTests
//
//  Created by Raju Dhumne on 25/09/25.
//

import XCTest
@testable import MenuApp

final class NetworkManagerTests: XCTestCase {
    
    // MARK: - Properties
    private var networkManager: NetworkManager!
    private var mockSession: MockURLSessionProtocol!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockSession = MockURLSessionProtocol()
        networkManager = NetworkManager(session: mockSession)
    }
    
    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSuccessfulRequest() async throws {
        // Given
        let expectedData = """
        {
            "id": 1,
            "name": "Test Item",
            "price": 10.99,
            "category": "test"
        }
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSession.mockData = expectedData
        mockSession.mockResponse = mockResponse
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        let result: MenuItem = try await networkManager.execute(request, responseType: MenuItem.self)
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "Test Item")
        XCTAssertEqual(result.price, 10.99)
        XCTAssertEqual(result.category, "test")
    }
    
    func testHTTPError() async {
        // Given
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSession.mockData = Data()
        mockSession.mockResponse = mockResponse
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When & Then
        do {
            let _: MenuItem = try await networkManager.execute(request, responseType: MenuItem.self)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            if case .httpError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected httpError with status code 404")
            }
        } catch {
            XCTFail("Expected NetworkError, got \(error)")
        }
    }
    
    func testDecodingError() async {
        // Given
        let invalidData = "invalid json".data(using: .utf8)!
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSession.mockData = invalidData
        mockSession.mockResponse = mockResponse
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When & Then
        do {
            let _: MenuItem = try await networkManager.execute(request, responseType: MenuItem.self)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            if case .decodingError = error {
                // Expected
            } else {
                XCTFail("Expected decodingError")
            }
        } catch {
            XCTFail("Expected NetworkError, got \(error)")
        }
    }
    
    func testInvalidResponse() async {
        // Given
        mockSession.mockData = Data()
        mockSession.mockResponse = nil // Invalid response
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When & Then
        do {
            let _: MenuItem = try await networkManager.execute(request, responseType: MenuItem.self)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            if case .invalidResponse = error {
                // Expected
            } else {
                XCTFail("Expected invalidResponse")
            }
        } catch {
            XCTFail("Expected NetworkError, got \(error)")
        }
    }
}

// MARK: - Mock URLSession Protocol
class MockURLSessionProtocol: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var dataCallCount = 0
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataCallCount += 1
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw NetworkError.invalidResponse
        }
        
        return (data, response)
    }
}

