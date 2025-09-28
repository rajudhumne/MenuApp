//
//  Router.swift
//  MenuApp
//
//  Created by Raju Dhumne on 28/09/25.
//

import Foundation

// MARK: - Router Protocol
protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}
