//
//  ErrorHandler.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import Foundation
import UIKit

// MARK: - Menu Error Types
enum MenuError: LocalizedError {
    case networkUnavailable
    case invalidData
    case itemNotFound
    case storyboardLoadingFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Please check your internet connection and try again"
        case .invalidData:
            return "Unable to load menu data. Please try again later"
        case .itemNotFound:
            return "Menu item not found"
        case .storyboardLoadingFailed:
            return "Unable to load the requested screen. Please try again later"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - Error Handler Protocol
protocol ErrorHandlerProtocol {
    func handle(_ error: Error, in viewController: UIViewController)
    func mapNetworkError(_ error: Error) -> MenuError
}

// MARK: - Error Handler Implementation
final class ErrorHandler: ErrorHandlerProtocol {
    
    func handle(_ error: Error, in viewController: UIViewController) {
        let menuError = mapNetworkError(error)
        
        let alert = UIAlertController(
            title: "Error",
            message: menuError.errorDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
    
    func mapNetworkError(_ error: Error) -> MenuError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidResponse, .httpError:
                return .networkUnavailable
            case .decodingError:
                return .invalidData
            }
        }
        return .unknown(error)
    }
}

