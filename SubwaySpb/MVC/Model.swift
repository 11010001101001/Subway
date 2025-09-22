import UIKit

struct Station : Hashable {
    var id : Int 
    var name : String
}

struct Vertex<T> {
    let data: T
}

struct Edge<T> {
    var source : Vertex<T>
    var destination : Vertex<T>
    let weight : Int
}

struct Singleton {
    static let graph = AdjacencyList<Station>()
    static var allVertexes: [Vertex<Station>] = []
    static var pathWay: [Int] = [] {
        didSet {
            print("Строим путь для:\(pathWay)")
            if pathWay.count > Constants.minStationsPathCount {
                pathWay.removeAll()
                graph.path.removeAll()
            }
        }
    }
    
    static func clearPath() {
        pathWay.removeAll()
        graph.path.removeAll()
        graph.pathDetails.removeAll()
    }
}

extension Vertex : Hashable where T : Hashable {}
extension Vertex : Equatable where T : Equatable {}
extension Vertex : CustomStringConvertible { var description : String { "\(data)" } }

