//
//  MenuItem.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import Foundation

struct MenuItem: Decodable {
    let id: Int
    let name: String
    let price: Double
    let category: String
}
