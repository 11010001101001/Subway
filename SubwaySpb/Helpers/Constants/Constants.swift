//
//  Constants.swift
//  MetroSpb
//
//  Created by Ярослав Куприянов on 21.10.2023.
//

import Foundation

enum Constants {
    static let maxDistance = 1000_000
    static let navBarFontSize: CGFloat = 20
    static let scale: CGFloat = 1.3
    static let animationDuration: TimeInterval = 0.2
    static let shadowOpacity: Float = 1
    static let shadowRadius: CGFloat = 10
    static let shadowOffset: CGSize = .zero
    static let minStationsPathCount = 2
    static let minZoomScale: CGFloat = 0.9
    static let maxZoomScale: CGFloat = 6
    static let stackSpacing: CGFloat = 8
    /// weights arrays from 1 to 72nd station - real data  from yandex maps in minutes
    static let weightStoreBlueLine : [Int] = [5,4,5,5,5,6,4,6,4,4,4,5,4,4,5,7,5]
    static let weightStoreRedLine: [Int] = [6,4,4,5,5,5,5,5,4,4,4,4,5,6,4,5,4,6]
    static let weightStorePurpleLine: [Int] = [5,4,5,4,5,5,5,5,5,4,5,5,6,6]
    static let weightStoreGreenLine: [Int] = [6,5,5,6,5,6,5,6,6,4,4]
    static let weightStoreOrangeLine: [Int] = [5,5,5,4,4,5,6]
}
