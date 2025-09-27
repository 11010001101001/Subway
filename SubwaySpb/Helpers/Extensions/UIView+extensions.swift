//
//  UIView+extensions.swift
//  MetroSpb
//
//  Created by Ярослав Куприянов on 21.10.2023.
//

import Foundation
import UIKit

typealias Action = (() -> Void)

extension UIView {
    func withAnimation(action: Action?, completion: Action? = nil) {
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: .zero,
            options: .curveEaseIn,
            animations: { action?() },
            completion: { _ in completion?() }
        )
    }
    
    func applyShadow() {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
    }
    
    func deselect() {
        layer.removeAllAnimations()
        transform = .identity
        removeShadow()
    }
    
    func select() {
        transform = CGAffineTransform(scaleX: Constants.scale, y: Constants.scale)
        applyShadow()
    }
}
