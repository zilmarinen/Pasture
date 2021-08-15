//
//  FoliageRing.swift
//
//  Created by Zack Brown on 04/07/2021.
//

import Euclid
import Foundation
import Meadow

struct FoliageRing: Prop {
    
    var peakCenter: Vector { (plane.normal * (height / 2.0)) }
    var baseCenter: Vector { (plane.normal * (height / 2.0)) }
    
    let plane: Euclid.Plane
    
    let height: Double
    let flop: Double
    let peakRadius: Double
    let baseRadius: Double
    
    let segments: Int
    
    let textureCoordinates: UVs
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        var slices: [[Vector]] = []
        
        let rotation = Euclid.Angle(radians: Math.pi2 / Double(segments))
        
        //
        /// Create peak and base vertices
        //
        
        var layer: [Vector] = []
        
        for index in 0..<(segments * 2) {
            
            let angle = (rotation / 2) * Double(index)
            
            var point = plot(radians: angle.radians, radius: baseRadius).project(onto: plane) + (plane.normal * -(height / 2.0))
            
            if index % 2 == 0 {
                
                point = point.lerp(peakCenter, flop)
            }
            
            layer.append(point)
        }
        
        slices.append(layer)
        
        if peakRadius > Math.epsilon {
            
            var layer: [Vector] = []
            
            for index in 0..<segments {
            
                let angle = rotation * Double(index)
            
                layer.append(plot(radians: angle.radians, radius: peakRadius).project(onto: plane) + (plane.normal * (height / 2.0)))
            }
            
            slices.append(layer)
        }
        else {
            
            slices.append([position + (plane.normal * (height / 2.0))])
        }
        
        //
        /// Create faces for peak, base and edge
        //
        
        guard let upper = slices.last,
              let lower = slices.first else { return [] }
        
        let uvStep = (textureCoordinates.end.x - textureCoordinates.start.x) / Double(segments)
        
        var polygons: [Euclid.Polygon] = []
        
        for segment in 0..<segments {
            
            let index = (segment * 2)
            
            let uvx0 = textureCoordinates.start.x + (uvStep * Double(segment))
            let uvx1 = textureCoordinates.start.x + (uvStep * Double(segment + 1))
            
            let uv0 = Vector(uvx1, textureCoordinates.start.y)
            let uv1 = Vector(uvx0, textureCoordinates.start.y)
            let uv2 = Vector(uvx0, textureCoordinates.end.y)
            let uv3 = Vector(uvx1, textureCoordinates.end.y)
            
            let peakUV = uv0.lerp(uv1, 0.5)
            let baseUV = uv3.lerp(uv2, 0.5)
            
            let v0 = position + lower[index]
            let v1 = position + lower[(index + 1) % lower.count]
            let v2 = position + lower[(index + 2) % lower.count]
            
            if peakRadius > Math.epsilon {
                
                let v3 = position + upper[(segment + 1) % upper.count]
                let v4 = position + upper[segment]
                
                guard let lhs = self.polygon(vectors: [v0, v1, v4], uvs: [uv3, uv2, peakUV]),
                      let middle = self.polygon(vectors: [v1, v3, v4], uvs: [uv3, uv2, peakUV]),
                      let rhs = self.polygon(vectors: [v1, v2, v3], uvs: [uv3, uv2, peakUV]),
                      let peak = self.polygon(vectors: [v4, v3, position + peakCenter], uvs: [uv3, uv2, peakUV]) else { continue }
                
                polygons.append(contentsOf: [lhs, middle, rhs, peak])
            }
            else {
                
                guard let lhs = self.polygon(vectors: [v0, v1, position + peakCenter], uvs: [uv3, uv2, peakUV]),
                      let rhs = self.polygon(vectors: [v1, v2, position + peakCenter], uvs: [uv3, uv2, peakUV]) else { continue }
                
                polygons.append(contentsOf: [lhs, rhs])
            }
            
            guard let lhs = self.polygon(vectors: [v1, v0, position - baseCenter], uvs: [uv3, uv2, baseUV]),
                  let rhs = self.polygon(vectors: [v2, v1, position - baseCenter], uvs: [uv3, uv2, baseUV]) else { continue }
            
            polygons.append(contentsOf: [lhs, rhs])
        }
        
        return polygons
    }
}
