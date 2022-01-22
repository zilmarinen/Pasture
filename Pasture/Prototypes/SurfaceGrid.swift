//
//  SurfaceGrid.swift
//
//  Created by Zack Brown on 04/11/2021.
//

import Euclid
import Foundation
import Meadow

struct SurfaceGrid {
    
    let center: Vector
    let radius: Double
    
    let corners: [Vector]
    
    init(position: Vector = .zero, radius: Double = 0.5) {
        
        self.center = position
        self.radius = radius
        self.corners = [position + Vector(x: -radius, y: 0, z: -radius),
                        position + Vector(x: radius, y: 0, z: -radius),
                        position + Vector(x: radius, y: 0, z: radius),
                        position + Vector(x: -radius, y: 0, z: radius)]
    }
}

extension SurfaceGrid {
    
    func corner(ordinal: Ordinal) -> Vector { corners[ordinal.corner] }
    
    func edge(cardinal: Cardinal) -> Vector {
        
        let (o0, o1) = cardinal.ordinals
        
        return corners[o0.corner].lerp(corners[o1.corner], 0.5)
    }
    
    func edge(o0: Ordinal, o1: Ordinal, interpolator: Double) -> Vector { corners[o0.corner].lerp(corners[o1.corner], interpolator) }
}
