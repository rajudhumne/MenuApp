//
//  MenuRouter.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import Foundation

// MARK: - Router Protocol
protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - MenuRouter
/// MenuRouter handles URL construction for menu API endpoints using enum-based routing
enum MenuRouter: Router {
    
    // MARK: - Cases
    case menu
    case menuItemDetail(id: Int)
    
    // MARK: - Constants
    private static let baseURL = "https://bfac43d8-02e4-4a01-9170-1a3dd3419ef7.mock.pstmn.io"
    
    // MARK: - Router Protocol Implementation
    
    /// The HTTP method for the endpoint
    var method: HTTPMethod {
        switch self {
        case .menu, .menuItemDetail:
            return .GET
        }
    }
    
    /// The path component of the URL
    var path: String {
        switch self {
        case .menu:
            return "/menu"
        case .menuItemDetail(let id):
            return "/menu/\(id)"
        }
    }
    
    /// The complete URL for the endpoint
    var url: URL? {
        return URL(string: Self.baseURL + path)
    }
    
    /// Creates a URLRequest for the endpoint
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
