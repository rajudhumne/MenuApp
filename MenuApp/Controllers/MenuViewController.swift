//
//  MenuViewController.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    private var viewModel: MenuViewModelProtocol
    private var dataSource: MenuViewDataSourceProtocol
    private let errorHandler: ErrorHandlerProtocol
    
    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: MenuViewModelProtocol,
          dataSource: MenuViewDataSourceProtocol = MenuTableViewDataSource(),
          errorHandler: ErrorHandlerProtocol = ErrorHandler()) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        self.errorHandler = errorHandler
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:viewModel:dataSource:errorHandler:)` to instantiate a `MenuViewController` instance.")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMenu()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Menu"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadingIndicator.startAnimating()
        
        // Setup data source
        tableView.dataSource = dataSource
        tableView.delegate = self
        // Set row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        viewModel.delegate = self   
    }
    
    private func loadMenu() {
        Task {
            try await viewModel.loadMenu()
        }
    }
    
    private func showError(_ error: Error) {
        errorHandler.handle(error, in: self)
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadingIndicator.startAnimating()
        Task {
            guard let menuItem = dataSource.getItem(at: indexPath) else { return }
            try await viewModel.selectItem(at: menuItem.id)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 16, y: 0, width: tableView.frame.width, height: 40)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.text = dataSource.getCategory(at: section)?.capitalized
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
}

extension MenuViewController: MenuViewModelDelegateProtocol {
    
    func didUpdateavailableItems(data: [String : [MenuItem]]) {
        dataSource.updateData(data)
        loadingIndicator.stopAnimating()
        tableView.reloadData()
    }

    func didSelectItem(_ item: MenuItemDetail) {
        loadingIndicator.stopAnimating()
        do {
            let vc = try createMenuDetailViewController(with: item)
            self.navigationController?.present(vc, animated: true)
        } catch {
            showError(error)
        }
    }
    
    // MARK: - Helper Methods
    private func createMenuDetailViewController(with item: MenuItemDetail) throws -> MenuDetailViewController {
        guard let storyboard = self.storyboard else {
            throw MenuError.storyboardLoadingFailed
        }
        
        let vc = storyboard.instantiateViewController(identifier: MenuDetailViewController.className, creator: { coder in
            return MenuDetailViewController(coder: coder, item: item)
        })
        return vc
    }
    
    func didFailWithError(_ error: Error) {
        loadingIndicator.stopAnimating()
        showError(error)   
    }
}
