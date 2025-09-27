//
//  PathCell.swift
//  MetroSpb
//
//  Created by Ярослав Куприянов on 21.10.2023.
//

import Foundation
import UIKit

final class PathCell: UITableViewCell {
    lazy var stationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stationLabel)
        NSLayoutConstraint.activate([
            stationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            stationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            stationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
