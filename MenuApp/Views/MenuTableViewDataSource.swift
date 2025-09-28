//
//  MenuTableViewDataSource.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import UIKit

// MARK: - Menu Table View Data Source
final class MenuTableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private var menuItems: [String: [MenuItem]] = [:]
    private var categories: [String] = []
    
    // MARK: - Public Methods
    func updateData(_ menuItems: [String: [MenuItem]]) {
        self.menuItems = menuItems
        self.categories = menuItems.keys.sorted()
    }
    
    func getItem(at indexPath: IndexPath) -> MenuItem? {
        let category = categories[indexPath.section]
        return menuItems[category]?[indexPath.row]
    }
    
    func getCategory(at section: Int) -> String? {
        guard section < categories.count else { return nil }
        return categories[section]
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let category = getCategory(at: section) else { return 0 }
        return menuItems[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.selectionStyle = .none
        var config = cell.defaultContentConfiguration()
        cell.selectionStyle = .none
        if let item = getItem(at: indexPath) {
            config.text = item.name
            config.secondaryText = String(format: "$%.2f", item.price)
            cell.contentConfiguration = config
            
        }
        return cell
    }
}
