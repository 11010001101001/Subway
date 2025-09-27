//
//  UINavigationBar+extensions.swift
//  MetroSpb
//
//  Created by Ярослав Куприянов on 21.10.2023.
//

import Foundation
import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: Constants.navBarFontSize, weight: .light),
            .foregroundColor: UIColor.white
        ]
    }
}
