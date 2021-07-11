//
//  TrunkSlice.swift
//
//  Created by Zack Brown on 02/07/2021.
//

import Euclid
import Foundation
import Meadow

struct TrunkSlice: Prop {
    
    enum Cap {
        
        case apex
        case throne
    }
    
    var peakCenter: Euclid.Vector { upper.average() }
    var baseCenter: Euclid.Vector { lower.average() }
    
    let upper: [Euclid.Vector]
    let lower: [Euclid.Vector]
    
    let cap: Cap?
    
    let textureCoordinates: UVs
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        guard upper.count == lower.count else { return [] }
        
        let uvStep = (textureCoordinates.end.x - textureCoordinates.start.x) / Double(upper.count)
        
        var polygons: [Euclid.Polygon] = []
        
        for segment in 0..<upper.count {
            
            let uvx0 = textureCoordinates.start.x + (uvStep * Double(segment))
            let uvx1 = textureCoordinates.start.x + (uvStep * Double(segment + 1))
            
            let uv0 = Euclid.Vector(uvx1, textureCoordinates.start.y)
            let uv1 = Euclid.Vector(uvx0, textureCoordinates.start.y)
            let uv2 = Euclid.Vector(uvx0, textureCoordinates.end.y)
            let uv3 = Euclid.Vector(uvx1, textureCoordinates.end.y)
            
            let peakUV = uv0.lerp(uv1, 0.5)
            let baseUV = uv3.lerp(uv2, 0.5)
            
            let v0 = position + upper[(segment + 1) % upper.count]
            let v1 = position + upper[segment]
            let v2 = position + lower[segment]
            let v3 = position + lower[(segment + 1) % upper.count]
            
            //
            /// Create edge face
            //
            
            guard let polygon = self.polygon(vectors: [v0, v1, v2], uvs: [uv0, uv1, uv2]) else { continue }
            
            polygons.append(polygon)
            
            guard let polygon = self.polygon(vectors: [v0, v2, v3], uvs: [uv0, uv2, uv3]) else { continue }
            
            polygons.append(polygon)
            
            //
            /// Create peak face
            //
            
            guard let polygon = self.polygon(vectors: [v1, v0, peakCenter], uvs: [uv1, uv0, peakUV]) else { continue }
            
            polygons.append(polygon)
            
            //
            /// Create base face
            //
            
            guard let polygon = self.polygon(vectors: [v3, v2, baseCenter], uvs: [uv3, uv2, baseUV]) else { continue }
            
            polygons.append(polygon)
        }
        
        return polygons
    }
}
