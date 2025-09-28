//
//  MenuDetailViewController.swift
//  MenuApp
//
//  Created by Raju Dhumne on 26/09/25.
//

import UIKit

class MenuDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var quantityContainerView: UIView!
    
    //MARK: - Local properties
    
    let item: MenuItemDetail
    private var quantity: Int = 1 {
        didSet {
            updateQuantityUI()
            updateAddToCartButton()
        }
    }
    
    // MARK: - Initizaliation
    init?(coder: NSCoder,item: MenuItemDetail) {
        self.item = item
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) { 
        fatalError("init(coder:) has not been implemented. Use init(coder:item:) instead.") 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        updateAddToCartButton()
        updateQuantityUI()
        addToCartButton.layer.cornerRadius = 10
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.loadImage(from: item.image)
        itemName.text = item.name
        itemDescription.text = item.description
        quantityContainerView?.addTopShadow()
    }
    
    // MARK: - Actions
    @IBAction func decrementButtonTapped(_ sender: UIButton) {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    @IBAction func incrementButtonTapped(_ sender: UIButton) {
        quantity += 1
    }
    
    @IBAction func addToCartButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Helper Functions
    private func updateQuantityUI() {
        quantityLabel?.text = "\(quantity)"
        decrementButton?.isEnabled = quantity > 1
        decrementButton?.alpha = quantity > 1 ? 1.0 : 0.5
    }
    
    private func updateAddToCartButton() {
        let totalPrice = item.price * Double(quantity)
        addToCartButton?.setTitle("Add to Cart • £\(totalPrice.toString())", for: .normal)
    }

    deinit {
        itemImageView?.cancelImageLoading()
        debugPrint("Deinit called for \(String(describing: self))")
    }
}
