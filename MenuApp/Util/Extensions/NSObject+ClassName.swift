//
//  NSObject+ClassName.swift
//  MenuApp
//
//  Created by Raju Dhumne on 28/09/25.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
}
