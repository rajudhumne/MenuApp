//
//  MenuViewModel.swift
//  MenuApp
//
//  Created by Raju Dhumne on 26/09/25.
//

import Foundation

protocol MenuViewModelProtocol {
    func loadMenu() async throws
    func selectItem(at index: Int) async throws
    var delegate: MenuViewModelDelegateProtocol? { get set }
}

@MainActor
protocol MenuViewModelDelegateProtocol {
    func didUpdateavailableItems(data: [String : [MenuItem]])
    func didSelectItem(_ item: MenuItemDetail)
    func didFailWithError(_ error: Error)
}

final class MenuViewModelImpl: MenuViewModelProtocol {
    
    private let menuRepository: MenuRepositoryProtocol
    
    var delegate: MenuViewModelDelegateProtocol?
    
    init(menuRepository: MenuRepositoryProtocol) {
        self.menuRepository = menuRepository
    }
    
    func loadMenu() async throws {
        do {
            let items = try await menuRepository.getMenu()
            let grouped = Dictionary(grouping: items, by: { $0.category })
            await delegate?.didUpdateavailableItems(data: grouped)
        } catch {
            await delegate?.didFailWithError(error)
        }
    }
    
    func selectItem(at index: Int) async throws {
        do {
            let item = try await menuRepository.getMenuItemDetail(id: index)
            await delegate?.didSelectItem(item)
        } catch {
            await delegate?.didFailWithError(error)
        }
    }
}
