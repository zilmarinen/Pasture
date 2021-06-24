//
//  Chonk.swift
//
//  Created by Zack Brown on 16/06/2021.
//

import Euclid
import Foundation
import Meadow

struct Chonk: Prop {
    
    var peakCenter: Euclid.Vector { position + (plane.normal * ((height / 2.0) + peak)) }
    var baseCenter: Euclid.Vector { position - (plane.normal * (base + (height / 2.0))) }
    
    let position: Euclid.Vector
    let plane: Euclid.Plane
    
    let peak: Double
    let base: Double
    let height: Double
    
    let peakRadius: Double
    let baseRadius: Double
    
    let segments: Int
    
    let textureCoordinates: UVs
    
    func build() -> [Euclid.Polygon] {
        
        var slices: [[Euclid.Vector]] = []
        
        //
        /// Create peak and base vertices
        //
        
        let rotation = Euclid.Angle(radians: Math.pi2 / Double(segments))
        
        for slice in 0...1 {
            
            var layer: [Euclid.Vector] = []
            
            let radius = slice == 0 ? baseRadius : peakRadius
            
            for segment in 0..<segments {
                
                let angle = rotation.radians * Double(segment)
                
                let distance = (slice == 0 ? -1 : 1) * (height / 2.0)
                
                layer.append(plot(radians: angle, radius: radius).project(onto: plane) + (plane.normal * distance))
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
            
            let uv0 = Euclid.Vector(uvx1, textureCoordinates.start.y)
            let uv1 = Euclid.Vector(uvx0, textureCoordinates.start.y)
            let uv2 = Euclid.Vector(uvx0, textureCoordinates.end.y)
            let uv3 = Euclid.Vector(uvx1, textureCoordinates.end.y)
            
            let peakUV = uv0.lerp(uv1, 0.5)
            let baseUV = uv3.lerp(uv2, 0.5)
            
            let v0 = position + upper[(segment + 1) % segments]
            let v1 = position + upper[segment]
            let v2 = position + lower[segment]
            let v3 = position + lower[(segment + 1) % segments]
            
            //
            /// Create edge face
            //
            
            var face = [v0, v1, v2, v3]
            var uvs = [uv0, uv1, uv2, uv3]
            
            guard let polygon = self.polygon(vectors: face, uvs: uvs) else { continue }
            
            polygons.append(polygon)
            
            //
            /// Create peak face
            //
            
            face = [v1, v0, peakCenter]
            uvs = [uv1, uv0, peakUV]
            
            guard let polygon = self.polygon(vectors: face, uvs: uvs) else { continue }
            
            polygons.append(polygon)
            
            //
            /// Create base face
            //
            
            face = [v3, v2, baseCenter]
            uvs = [uv3, uv2, baseUV]
            
            guard let polygon = self.polygon(vectors: face, uvs: uvs) else { continue }
            
            polygons.append(polygon)
        }
        
        return polygons
    }
}
