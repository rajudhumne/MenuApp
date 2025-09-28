//
//  Numeric+StringFormat.swift
//  MenuApp
//
//  Created by Raju Dhumne on 28/09/25.
//

import Foundation

extension Double {
    /// Formats the double to a string with given decimal places
    func toString(decimalPlaces: Int = 2) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}
