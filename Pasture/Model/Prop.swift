//
//  Prop.swift
//
//  Created by Zack Brown on 16/06/2021.
//

import Euclid
import Foundation
import Meadow

protocol Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon]
}

extension Prop {
    
    func curve(start: Euclid.Vector, end: Euclid.Vector, control: Euclid.Vector, interpolator: Double) -> Euclid.Vector {
        
        let ab = start.lerp(control, interpolator)
        let bc = control.lerp(end, interpolator)
        
        return ab.lerp(bc, interpolator)
    }
    
    func plot(radians: Double, radius: Double) -> Euclid.Vector {
        
        return Euclid.Vector(sin(radians) * radius, 0, cos(radians) * radius)
    }
}

extension Prop {
    
    func polygon(vectors: [Euclid.Vector], uvs: [Euclid.Vector]) -> Euclid.Polygon? {
        
        guard vectors.count == uvs.count else { return nil }
        
        let normal = vectors.normal()
        
        var vertices: [Euclid.Vertex] = []
        
        for index in vectors.indices {
            
            vertices.append(Vertex(vectors[index], normal, uvs[index]))
        }
        
        return Polygon(vertices)
    }
}
