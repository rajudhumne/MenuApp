//
//  MenuRepository.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import Foundation

protocol MenuRepositoryProtocol {
    func getMenu() async throws -> [MenuItem]
    func getMenuItemDetail(id: Int) async throws -> MenuItemDetail
}

final class MenuRepository: MenuRepositoryProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getMenu() async throws -> [MenuItem] {
        guard let request = MenuRouter.menu.urlRequest else {
            throw NetworkError.invalidResponse
        }
        return try await networkManager.execute(request, responseType: [MenuItem].self)
    }
    
    func getMenuItemDetail(id: Int) async throws -> MenuItemDetail {
        guard let request = MenuRouter.menuItemDetail(id: id).urlRequest else {
            throw NetworkError.invalidResponse
        }
        return try await networkManager.execute(request, responseType: MenuItemDetail.self)
    }
}


