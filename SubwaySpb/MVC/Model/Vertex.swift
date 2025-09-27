//
//  Vertex.swift
//  SubwaySbp
//
//  Created by Ярослав Куприянов on 23.09.2025.
//

import Foundation

struct Vertex<T> {
    let data: T
}

extension Vertex : Hashable where T : Hashable {}
extension Vertex : Equatable where T : Equatable {}
extension Vertex : CustomStringConvertible { var description : String { "\(data)" } }
