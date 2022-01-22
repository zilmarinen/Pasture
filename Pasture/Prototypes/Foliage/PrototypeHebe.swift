//
//  PrototypeHebe.swift
//
//  Created by Zack Brown on 22/01/2022.
//

import Euclid
import Harvest
import Meadow

struct PrototypeHebe: PrototypeFoliage {
    
    enum Constants {
        
        static let ratio = Math.golden / 2.0
    }
    
    var species: Species { .gingko }
    var footprint: Wireframe.Footprint
    
    var mesh: Mesh {
        
        let stump = PrefabStump(shape: .sapling)
        let canopy = PrefabCanopy(shape: .oct, colorPalette: .hebe)
        
        let size = footprint.size / 2.0
        
        let stumpRadius = size.x * (Constants.ratio / 4)
        
        let canopySize = size * Constants.ratio
        let stumpSize = Vector(x: stumpRadius, y: size.y - canopySize.y, z: stumpRadius)
        
        let canopyPosition = Vector(x: 0, y: stumpSize.y, z: 0)
        
        var mesh = Mesh([])
        
        let grid = SurfaceGrid(position: .zero, radius: 0.25 * footprint.size.x)
        
        for ordinal in Ordinal.allCases {
            
            let position = grid.corner(ordinal: ordinal)
            
            let m0 = stump.mesh(position: position, size: stumpSize)
            let m1 = canopy.mesh(position: position + canopyPosition, size: canopySize)
            
            mesh = mesh.union(m0.union(m1))
        }
        
        return mesh
    }
}
