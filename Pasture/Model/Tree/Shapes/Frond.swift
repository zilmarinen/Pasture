//
//  Frond.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import Euclid
import Foundation
import Meadow

struct Frond: Prop {
    
    let position: Euclid.Vector
    let plane: Euclid.Plane
    
    let angle: Double
    let radius: Double
    let width: Double
    let spread: Double
    
    let segments: Int
    
    let textureCoordinates: UVs

    func build() -> [Euclid.Polygon] {
            
        let step = Double(1.0 / Double(segments))
        let uvStep = (textureCoordinates.end.y - textureCoordinates.start.y) / Double(segments)
        
        let randomX = Math.random(minimum: -1, maximum: 1)
        let randomY = Math.random(minimum: -1, maximum: 1)
        let randomZ = Math.random(minimum: -1, maximum: 1)
        
        let offset = Vector(randomX * spread, randomY * spread, randomZ * spread)
        let anchor = plot(radians: angle, radius: radius)
        let control = anchor.project(onto: plane) + Vector(0, position.y, 0)
        let end = Vector(anchor.x + offset.x, position.y - (radius + offset.y), anchor.z + offset.z)
        let middle = curve(start: position, end: end, control: control, interpolator: 0.5)
        let perpendicular = [position, middle, end].normal()
        var length = Math.ease(curve: .out, value: step) * width
        
        var sweep = (lhs: position + (perpendicular * length),
                     curve: position,
                     rhs: position + (-perpendicular * length))
        
        var polygons: [Euclid.Polygon] = []
        
        for segment in 1..<segments {

            let interpolator = step * Double(segment)
            
            let uvy0 = textureCoordinates.start.x + (uvStep * Double(segment))
            let uvy1 = textureCoordinates.start.x + (uvStep * Double(segment + 1))
            
            let uv0 = Euclid.Vector(textureCoordinates.end.x, uvy0)
            let uv1 = Euclid.Vector(textureCoordinates.start.x, uvy0)
            let uv2 = Euclid.Vector(textureCoordinates.start.x, uvy1)
            let uv3 = Euclid.Vector(textureCoordinates.end.x, uvy1)
                                    
            let peakUV = uv0.lerp(uv1, 0.5)
            let baseUV = uv3.lerp(uv2, 0.5)

            let point = curve(start: position, end: end, control: control, interpolator: interpolator)
            
            length = Math.ease(curve: .out, value: interpolator) * width
            
            let current = (lhs: (point + (perpendicular * length)),
                           curve: point,
                           rhs: (point + (-perpendicular * length)))
            
            //
            /// Create left and right upper faces
            //
            
            var face = [sweep.curve, sweep.rhs, current.rhs, current.curve]
            var uvs = [peakUV, uv0, uv3, baseUV]

            guard let polygon = self.polygon(vectors: face, uvs: uvs) else { continue }

            polygons.append(polygon)

            face = [sweep.lhs, sweep.curve, current.curve, current.lhs]
            uvs = [uv1, peakUV, baseUV, uv2]

            guard let polygon = self.polygon(vectors: face, uvs: uvs) else { continue }

            polygons.append(polygon)
            
            sweep = current
        }
        
        let uvy0 = textureCoordinates.start.x + (uvStep * Double(segments - 1))
        let uvy1 = textureCoordinates.start.x + (uvStep * Double(segments))
        
        let uv0 = Euclid.Vector(textureCoordinates.end.x, uvy0)
        let uv1 = Euclid.Vector(textureCoordinates.start.x, uvy0)
        let uv2 = Euclid.Vector(textureCoordinates.start.x, uvy1)
        let uv3 = Euclid.Vector(textureCoordinates.end.x, uvy1)
                                
        let baseUV = uv3.lerp(uv2, 0.5)
        
        let face = [sweep.lhs, sweep.rhs, end]
        let uvs = [uv1, uv0, baseUV]
        
        guard let polygon = self.polygon(vectors: face, uvs: uvs) else { return polygons }
        
        polygons.append(polygon)
        
        return polygons
    }
}
