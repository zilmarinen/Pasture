//
//  Array.swift
//
//  Created by Zack Brown on 22/07/2021.
//

import Euclid
import Foundation
import Meadow

extension Array where Element == Euclid.Vector {
    
    typealias Grid = (corners: (inner: [Euclid.Vector],
                                outer: [Euclid.Vector]),
                      edges: (inner: [Cardinal : (c0: Euclid.Vector, c1: Euclid.Vector)],
                              outer: [Cardinal : (c0: Euclid.Vector, c1: Euclid.Vector)]))
    
    enum Axis {
        
        case y
        case z
    }
    
    func inset(axis: Axis, corner: Double, edge: Double) -> Grid {
        
        var corners = self
        var edges: (inner: [Cardinal : (Euclid.Vector, Euclid.Vector)],
                    outer: [Cardinal : (Euclid.Vector, Euclid.Vector)]) = ([:], [:])
        
        for cardinal in Cardinal.allCases {
         
            let (o0, o1) = cardinal.ordinals
            let normal = axis == .y ? Vector(cardinal.normal.x, cardinal.normal.z, cardinal.normal.y) : Vector(cardinal.normal.x, cardinal.normal.y, cardinal.normal.z)
            
            corners[o0.rawValue] = corners[o0.rawValue] + (-normal * corner)
            corners[o1.rawValue] = corners[o1.rawValue] + (-normal * corner)
        }
        
        let maxEdge = Swift.max(0, Swift.min(corner, edge))
        
        for cardinal in Cardinal.allCases {
         
            let (o0, o1) = cardinal.ordinals
            let normal = axis == .y ? Vector(cardinal.normal.x, cardinal.normal.z, cardinal.normal.y) : Vector(cardinal.normal.x, cardinal.normal.y, cardinal.normal.z)
            
            let v0 = corners[o0.rawValue]
            let v1 = corners[o1.rawValue]
            
            edges.outer[cardinal] = (v0 + (normal * maxEdge), v1 + (normal * maxEdge))
            edges.inner[cardinal] = (v0.lerp(v1, edge), v1.lerp(v0, edge))
        }
        
        return ((corners, self), edges)
    }
}
