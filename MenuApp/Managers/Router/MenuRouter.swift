//
//  MenuRouter.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import Foundation

// MARK: - MenuRouter
enum MenuRouter: Router {
    
    // MARK: - Cases
    case menu
    case menuItemDetail(id: Int)
    
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
        let baseUrl: String = AppConfig.value(for: .baseApiUrl)
        let fullUrl = baseUrl + path
        return URL(string: fullUrl)
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
