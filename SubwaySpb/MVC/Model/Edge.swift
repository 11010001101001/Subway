//
//  Edge.swift
//  SubwaySbp
//
//  Created by Ярослав Куприянов on 23.09.2025.
//

import Foundation

struct Edge<T> {
    var source : Vertex<T>
    var destination : Vertex<T>
    let weight : Int
}
