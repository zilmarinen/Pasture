//
//  Chonk.swift
//
//  Created by Zack Brown on 16/06/2021.
//

import Euclid
import Foundation
import Meadow

struct Chonk: Prop {
    
    var peakCenter: Vector { (plane.normal * ((height / 2.0) + peak)) }
    var baseCenter: Vector { (plane.normal * (base + (height / 2.0))) }
    
    let plane: Euclid.Plane
    
    let peak: Double
    let base: Double
    let height: Double
    
    let peakRadius: Double
    let baseRadius: Double
    
    let segments: Int
    
    let textureCoordinates: UVs
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        var slices: [[Vector]] = []
        
        //
        /// Create peak and base vertices
        //
        
        let rotation = Euclid.Angle(radians: Math.pi2 / Double(segments))
        
        for slice in 0...1 {
            
            var layer: [Vector] = []
            
            let radius = slice == 0 ? baseRadius : peakRadius
            
            for segment in 0..<segments {
                
                let angle = rotation * Double(segment)
                
                let distance = (slice == 0 ? -1 : 1) * (height / 2.0)
                
                layer.append(plot(radians: angle.radians, radius: radius).project(onto: plane) + (plane.normal * distance))
            }
            
            slices.append(layer)
        }
        
        //
        /// Create faces for peak, base and edge
        //
        
        guard let upper = slices.last,
              let lower = slices.first else { return [] }
        
        let uvStep = (textureCoordinates.end.x - textureCoordinates.start.x) / Double(segments)
        
        var polygons: [Euclid.Polygon] = []
        
        for segment in 0..<segments {
            
            let uvx0 = textureCoordinates.start.x + (uvStep * Double(segment))
            let uvx1 = textureCoordinates.start.x + (uvStep * Double(segment + 1))
            
            let uv0 = Vector(uvx1, textureCoordinates.start.y)
            let uv1 = Vector(uvx0, textureCoordinates.start.y)
            let uv2 = Vector(uvx0, textureCoordinates.end.y)
            let uv3 = Vector(uvx1, textureCoordinates.end.y)
            
            let peakUV = uv0.lerp(uv1, 0.5)
            let baseUV = uv3.lerp(uv2, 0.5)
            
            let v0 = position + upper[(segment + 1) % segments]
            let v1 = position + upper[segment]
            let v2 = position + lower[segment]
            let v3 = position + lower[(segment + 1) % segments]
            
            //
            /// Create edge face
            //
            
            guard let lhs = self.polygon(vectors: [v0, v1, v2], uvs: [uv0, uv1, uv2]),
                  let rhs = self.polygon(vectors: [v0, v2, v3], uvs: [uv0, uv2, uv3]) else { continue }
            
            polygons.append(contentsOf: [lhs, rhs])
            
            //
            /// Create peak face
            //
            
            guard let polygon = self.polygon(vectors: [v1, v0, position + peakCenter], uvs: [uv1, uv0, peakUV]) else { continue }
            
            polygons.append(polygon)
            
            //
            /// Create base face
            //
            
            guard let polygon = self.polygon(vectors: [v3, v2, position - baseCenter], uvs: [uv3, uv2, baseUV]) else { continue }
            
            polygons.append(polygon)
        }
        
        return polygons
    }
}
