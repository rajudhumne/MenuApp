//
//  UIView+Ext.swift
//  MenuApp
//
//  Created by Raju Dhumne on 27/09/25.
//

import UIKit

extension UIView {
    func addTopShadow(color: UIColor = UIColor.black,
                      opacity: Float = 0.2,
                      offset: CGSize = CGSize(width: 0, height: -3),
                      radius: CGFloat = 5) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
        
        // Optional: Add shadow path for better performance
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
