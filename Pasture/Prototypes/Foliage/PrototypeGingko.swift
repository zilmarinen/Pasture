//
//  PrototypeGingko.swift
//
//  Created by Zack Brown on 29/10/2021.
//

import Euclid
import Harvest
import Meadow

struct PrototypeGingko: PrototypeFoliage {
    
    enum Constants {
        
        static let ratio = Math.golden / 2.0
    }
    
    var species: Species { .gingko }
    var footprint: Wireframe.Footprint
    
    var mesh: Mesh {
        
        let stump = PrefabStump(shape: .sapling)
        let canopy = PrefabCanopy(shape: .tri, colorPalette: .gingko)
        
        let stumpRadius = footprint.size.x * (Constants.ratio / 4)
        
        let canopySize = footprint.size * Constants.ratio
        let stumpSize = Vector(x: stumpRadius, y: footprint.size.y - canopySize.y, z: stumpRadius)
        
        let canopyPosition = Vector(x: 0, y: stumpSize.y, z: 0)
        
        let m0 = stump.mesh(position: .zero, size: stumpSize)
        let m1 = canopy.mesh(position: canopyPosition, size: canopySize)
        
        return m0.union(m1)
    }
}
