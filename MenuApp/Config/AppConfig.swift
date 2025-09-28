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
}
