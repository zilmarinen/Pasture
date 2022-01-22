//
//  PrototypeBamboo.swift
//
//  Created by Zack Brown on 24/10/2021.
//

import Euclid
import Harvest
import Meadow

struct PrototypeBamboo: PrototypeFoliage {
    
    enum Constants {
        
        static let ratio = Math.golden / 2.0
    }
    
    var species: Species { .bamboo }
    var footprint: Wireframe.Footprint
    
    var mesh: Mesh {
        
        let p0 = PrefabBambooChute(segments: 5, sides: 14)
        let p1 = PrefabBambooChute(segments: 3, sides: 14)
        let p2 = PrefabBambooChute(segments: 3, sides: 14)
        
        let b0 = p0.mesh(position: Vector(x: -0.125, y: 0, z: 0), size: Vector(x: 0.125, y: footprint.size.y, z: 0.25))
        let b1 = p1.mesh(position: Vector(x: 0.125, y: 0, z: 0.125), size: Vector(x: 0.125, y: footprint.size.y / 1.4, z: 0.25))
        let b2 = p2.mesh(position: Vector(x: 0.125, y: 0, z: -0.125), size: Vector(x: 0.125, y: footprint.size.y / 2, z: 0.25))
        
        return b0.union(b1).union(b2)
    }
}
