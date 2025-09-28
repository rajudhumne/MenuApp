//
//  MenuViewDataSourceProtocol.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import UIKit

protocol MenuViewDataSourceProtocol: UITableViewDataSource {
    func updateData(_ menuItems: [String: [MenuItem]])
    func getItem(at indexPath: IndexPath) -> MenuItem?
    func getCategory(at section: Int) -> String?
}

