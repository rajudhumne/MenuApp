//
//  AppConfig.swift
//  MenuApp
//
//  Created by Raju Dhumne on 28/09/25.
//

import Foundation

/// AppConfig provides type-safe access to configuration values from Info.plist
class AppConfig {
    /// Configuration keys that can be accessed
    enum Key: String {
        case baseApiUrl = "BASE_API_URL"
    }
    
    /// Errors that can occur when accessing configuration values
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    /// Retrieves a configuration value for the specified key
    /// - Parameter key: The configuration key to retrieve
    /// - Returns: The configuration value cast to the specified type
    /// - Throws: Fatal error if key is missing or value cannot be converted
    static func value<T>(for key: Key) -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
            fatalError("Missing env key")
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            fatalError("Wrong type for env key")
        }
    }
    
    /// Returns the base URL for API requests.
    ///
    /// NOTE: We prepend "https://" here instead of including it in the xcconfig file
    /// because `.xcconfig` treats `//` as a comment delimiter. Including the scheme
    /// in the xcconfig would break the value parsing. This ensures a valid URL
    /// while keeping xcconfig files clean per environment.
    static func string(for key: Key) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            fatalError("Missing or invalid value for key \(key.rawValue)")
        }
        return value
    }
    
    static var baseUrl: URL {
        let rawValue = string(for: .baseApiUrl)
        guard let url = URL(string: rawValue.hasPrefix("http") ? rawValue : "https://\(rawValue)") else {
            fatalError("Invalid URL string: \(rawValue)")
        }
        return url
    }
}
