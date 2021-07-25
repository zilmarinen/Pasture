//
//  Pentomino.swift
//
//  Created by Zack Brown on 30/06/2021.
//

import Foundation
import Meadow

enum Pentomino: String, Codable, CaseIterable, Identifiable {
    
    case f
    case i
    case l
    case n
    case p
    case t
    case u
    case v
    case w
    case x
    case y
    case z
    
    var id: String { self.rawValue }
    
    var footprint: Footprint {
        
        switch self {
            
        case .f: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .i: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -2),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 0, y: 0, z: 2)])
            
        case .l: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -2),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 1, y: 0, z: 1)])
            
        case .n: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -2),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: -1, y: 0, z: 1)])
            
        case .p: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .t: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .u: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0)])
            
        case .v: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -2),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 2, y: 0, z: 0)])
            
        case .w: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 1)])
            
        case .x: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .y: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 0, y: 0, z: 2)])
            
        case .z: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 1, y: 0, z: 1)])
        }
    }
}
