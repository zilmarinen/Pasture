//
//  BeechTree.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import Euclid
import Foundation
import GameKit
import Meadow
import SwiftUI

class BeechTree: Codable, Hashable, ObservableObject {
    
    static let `default`: BeechTree = BeechTree(trunk: .default)
    
    enum CodingKeys: CodingKey {
        
        case trunk
    }
    
    @Published var trunk: TreeTrunk
    
    init(trunk: TreeTrunk) {
        
        self.trunk = trunk
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        trunk = try container.decode(TreeTrunk.self, forKey: .trunk)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(trunk, forKey: .trunk)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(trunk)
    }
    
    static func == (lhs: BeechTree, rhs: BeechTree) -> Bool {
        
        return  lhs.trunk == rhs.trunk
    }
}

extension BeechTree: Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        guard let plane = Plane(normal: .up, pointOnPlane: .zero) else { return [] }
        
        //
        /// Create trunk
        //
        
        let t = trunk.build(position: position, plane: plane)
        
        var mesh = Mesh(t.polygons)
        mesh = Mesh([])
        //
        /// Create foliage
        //
        
        let grid = SDFGrid(footprint: Footprint(coordinate: .zero, nodes: [.zero, .forward, .right, -.forward, -.right]), resolution: 8)
        
        let s0 = SDFSphere(position: Vector(0, 0, 0), radius: 0.5)
        
        let s1 = SDFSphere(position: Vector(0, trunk.trunk.height + 0.5, 0), radius: 0.75)
        
        let g0 = SDFGroup(method: .minimum, shapes: [s0, s1])
        
        grid.add(shape: g0)
        //grid.add(shape: s0)
        //grid.add(shape: s1)
        
        mesh = mesh.union(Mesh(grid.march(method: .tetrahedron)))
        
        return mesh.polygons
    }
}
