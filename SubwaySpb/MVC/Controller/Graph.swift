import Foundation
import UIKit

protocol GraphProtocol: AnyObject {
    var path: [Vertex<Station>] { get }
    var info: [Int: String] { get }
    var pathDetails: [String] { get }
    var allVertexes: [Vertex<Station>] { get }
    var pathWay: [Int] { get }

    func add(from source: Vertex<Station>, to destination: Vertex<Station>, weight: Int)
    func calculateShortestPath(from: Vertex<Station>, to: Vertex<Station>)
    func clearPath()
    func addVertexesCrossings()
    func addVertexesAndEdgesToGraph(arrStations: [Station], arrWeights: [Int])
    func append(vertex: Vertex<Station>, name: String, id: Int)
    func insertBigStationId(id: Int)
    func appendViewTag(tag: Int)
}

final class Graph<T: Hashable> {
    private(set) var path: [Vertex<Station>] = []
    private(set) var info: [Int: String] = [:]
    private(set) var pathDetails = [String]()
    private(set) var allVertexes: [Vertex<Station>] = []
    private(set) var pathWay: [Int] = [] {
        didSet {
            print("Строим путь для:\(pathWay)")
            if pathWay.count > Constants.minStationsPathCount {
                pathWay.removeAll()
                path.removeAll()
            }
        }
    }

    private var bigStationsArrIds: Set<Int> = []
    private var adjacencies: [Vertex<Station>: [Edge<Station>]] = [:]
    private var pathDict: [Vertex<Station>: Vertex<Station>] = [:]
    private var distancies: [Vertex<Station>: Int] = [:]
    private var distanciesCopy: [Vertex<Station>: Int] = [:]
}

extension Graph: GraphProtocol {
    /// Dijkstra's Algorithm
    func calculateShortestPath(from: Vertex<Station>, to: Vertex<Station>) {
        var shortestPath = [Vertex<Station>: Int]()

        /// Setting max distancies to all vertexes except `from` vertex
        distancies[from] = .zero
        for vertex in allVertexes where vertex != from {
            distancies[vertex] = Constants.maxDistance
        }

        /// Visiting all vertexes to find the shortest path and mark visited ones
        while distancies.values.contains(Constants.maxDistance) {
            guard let closest = distancies.sorted(by: { $0.value < $1.value }).first?.key,
                  let edges = adjacencies[closest]
            else { return }
            shortestPath[closest] = distancies[closest]
            edges.forEach {
                let oldDistance = distancies[$0.destination] ?? .zero
                let newDistance = (distancies[closest] ?? .zero) + $0.weight

                if newDistance < oldDistance {
                    distancies[$0.destination] = newDistance
                    distanciesCopy[$0.destination] = newDistance
                    // add previous vertex according to the shortest path
                    pathDict[$0.destination] = $0.source
                }
            }
            // mark visited vertex by it's deleting from dict
            distancies.removeValue(forKey: closest)
        }

        /// finding the shortest path, reversing the path to get right direction
        path.append(to)
        for _ in 0...pathDict.count {
            if let lastStation = path.last,
               lastStation != from,
               let previousVertex = pathDict[lastStation]
            {
                path.append(previousVertex)
            }
        }
        path.reverse()

        /// logging path info
        let sortedDistancies = distanciesCopy.sorted(by: { $0.value < $1.value })
        sortedDistancies.forEach {
            let station = $0.key
            guard station != from else { return }
            let stationName = station.data.name
            let distanceToStation = $0.value

            if path.contains(station) {
                pathDetails.append("\(distanceToStation)' до станции \(stationName)")
            }
        }
    }
    
    func appendViewTag(tag: Int) {
        pathWay.append(tag)
    }

    func append(vertex: Vertex<Station>, name: String, id: Int) {
        allVertexes.append(vertex)
        info[id] = name
    }
    
    func add(from source:Vertex<Station>, to destination: Vertex<Station>, weight: Int) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        var arr: [Edge<Station>] = []

        arr.append(edge)

        if adjacencies.keys.contains(source) {
            adjacencies[source]?.append(edge)
        } else {
            adjacencies[source] = arr
        }
    }

    func clearPath() {
        pathWay.removeAll()
        path.removeAll()
        pathDetails.removeAll()
    }

    // MARK: Adding to graph vertexes and edges
    func addVertexesAndEdgesToGraph(arrStations: [Station], arrWeights: [Int]) {
        for (index,value) in arrStations.enumerated() {
            let nextIndex = index + 1

            if nextIndex != arrStations.count {
                /// one direction
                add(from: Vertex(data: Station(id: value.id,
                                               name: arrStations[index].name)),
                    to: Vertex(data: Station(id: value.id + 1,
                                             name: arrStations[nextIndex].name)),
                    weight: arrWeights[index])
                /// another directions
                add(from: Vertex(data: Station(id: value.id + 1,
                                               name: arrStations[nextIndex].name)),
                    to: Vertex(data: Station(id: value.id,
                                             name: arrStations[index].name)),
                    weight: arrWeights[index])
            }
        }
    }

    func addVertexesCrossings() {
        /// let's add stations connections - important - for both directions
        add(from: Vertex(data: Station(id: 9, name: "Невский проспект")),
            to: Vertex(data: Station(id: 57, name: "Гостиный двор")),
            weight: 4)
        add(from: Vertex(data: Station(id: 57, name: "Гостиный двор")),
            to: Vertex(data: Station(id: 9, name: "Невский проспект")),
            weight: 4)

        add(from: Vertex(data: Station(id: 28, name: "Площадь восстания")),
            to: Vertex(data: Station(id: 58, name: "Маяковская")),
            weight: 3)
        add(from: Vertex(data: Station(id: 58, name: "Маяковская")),
            to: Vertex(data: Station(id: 28, name: "Площадь восстания")),
            weight: 3)

        add(from: Vertex(data: Station(id: 10, name: "Сенная площадь")),
            to: Vertex(data: Station(id: 44, name: "Садовая")),
            weight: 4)
        add(from: Vertex(data: Station(id: 10, name: "Сенная площадь")),
            to: Vertex(data: Station(id: 65, name: "Спасская")),
            weight: 4)
        add(from: Vertex(data: Station(id: 44, name: "Садовая")),
            to: Vertex(data: Station(id: 65, name: "Спасская")),
            weight: 3)
        add(from: Vertex(data: Station(id: 44, name: "Садовая")),
            to: Vertex(data: Station(id: 10, name: "Сенная площадь")),
            weight: 4)
        add(from: Vertex(data: Station(id: 65, name: "Спасская")),
            to: Vertex(data: Station(id: 10, name: "Сенная площадь")),
            weight: 4)
        add(from: Vertex(data: Station(id: 65, name: "Спасская")),
            to: Vertex(data: Station(id: 44, name: "Садовая")),
            weight: 3)

        add(from: Vertex(data: Station(id: 29, name: "Владимирская")),
            to: Vertex(data: Station(id: 66, name: "Достоевская")),
            weight: 3)
        add(from: Vertex(data: Station(id: 66, name: "Достоевская")),
            to: Vertex(data: Station(id: 29, name: "Владимирская")),
            weight: 3)

        add(from: Vertex(data: Station(id: 59, name: "Площадь Александра Невского 1")),
            to: Vertex(data: Station(id: 68, name: "Площадь Александра Невского 2")),
            weight: 3)
        add(from: Vertex(data: Station(id: 68, name: "Площадь Александра Невского 2")),
            to: Vertex(data: Station(id: 59, name: "Площадь Александра Невского 1")),
            weight: 3)

        add(from: Vertex(data: Station(id: 30, name: "Пушкинская")),
            to: Vertex(data: Station(id: 45, name: "Звенигородская")),
            weight: 3)
        add(from: Vertex(data: Station(id: 45, name: "Звенигородская")),
            to: Vertex(data: Station(id: 30, name: "Пушкинская")),
            weight: 3)

        add(from: Vertex(data: Station(id: 11, name: "Технологический институт 2")),
            to: Vertex(data: Station(id: 31, name: "Технологический институт 1")),
            weight: 2)
        add(from: Vertex(data: Station(id: 31, name: "Технологический институт 1")),
            to: Vertex(data: Station(id: 11, name: "Технологический институт 2")),
            weight: 2)
    }

    func insertBigStationId(id: Int) {
        bigStationsArrIds.insert(id)
    }
}
