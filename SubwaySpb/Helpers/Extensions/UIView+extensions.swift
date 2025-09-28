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
    func withAnimation(duration: CGFloat? = nil, action: Action?, completion: Action? = nil) {
        UIView.animate(
            withDuration: duration ?? Constants.animationDuration,
            delay: .zero,
            options: .curveEaseIn,
            animations: { action?() },
            completion: { _ in completion?() }
        )
    }
    
    func deselect() {
        layer.removeAllAnimations()
        transform = .identity
        layer.shadowColor = UIColor.clear.cgColor
        layer.borderWidth = 0.5
    }
    
    func select() {
        transform = CGAffineTransform(scaleX: Constants.scale, y: Constants.scale)
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius
        layer.borderWidth = 1
    }
}
