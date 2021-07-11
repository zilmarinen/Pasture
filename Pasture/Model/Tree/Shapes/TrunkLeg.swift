//
//  TrunkLeg.swift
//
//  Created by Zack Brown on 01/07/2021.
//

import Euclid
import Foundation
import GameKit
import Meadow

struct TrunkLeg: Prop {
    
    enum Constants {
        
        static let floor: Double = -0.05
    }
    
    let plane: Euclid.Plane
    let noise: Noise
    
    let angle: Double
    let spread: Double
    
    let innerRadius: Double
    let outerRadius: Double
    
    let peak: Double
    let base: Double
    
    let segments: Int
    
    let textureCoordinates: UVs
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        let step = Double(1.0 / Double(segments))
        let uvStep = (textureCoordinates.end.y - textureCoordinates.start.y) / Double(segments)
        
        let size = Vector(Double(segments), 0, Double(segments))
        let sampleCount = Vector(Double(segments), 0, Double(segments))
        
        let map = noise.map(size: size, sampleCount: sampleCount)
        
        let s0 = Double(map.value(at: vector2(1, 0)))
        let s1 = Double(map.value(at: vector2(0, Int32(segments))))
        
        let start = plot(radians: angle, radius: innerRadius)
        var end = plot(radians: angle, radius: outerRadius)
        let control = start.lerp(end, 0.5)
        let perpendicular = [start, start + .up, end].normal()
        
        end = Vector(end.x + (s0 * spread), base, end.z + (s1 * spread))
        
        var polygons: [Euclid.Polygon] = []
        
        var sweep = (lhs: (start + (-perpendicular * base)).project(onto: plane) + (plane.normal * peak),
                     curve: start.project(onto: plane) + (plane.normal * peak),
                     rhs: (start + (perpendicular * base)).project(onto: plane) + (plane.normal * peak))
        
        for segment in 0...segments {
            
            let interpolator = step * Double(segment)

            let uvy0 = textureCoordinates.start.y + (uvStep * Double(segment))
            let uvy1 = textureCoordinates.start.y + (uvStep * Double(segment + 1))

            let uv0 = Euclid.Vector(textureCoordinates.end.x, uvy0)
            let uv1 = Euclid.Vector(textureCoordinates.start.x, uvy0)
            let uv2 = Euclid.Vector(textureCoordinates.start.x, uvy1)
            let uv3 = Euclid.Vector(textureCoordinates.end.x, uvy1)

            let peakUV = uv0.lerp(uv1, 0.5)
            let baseUV = uv3.lerp(uv2, 0.5)

            let point = curve(start: start + Vector(0, peak, 0), end: end, control: control, interpolator: interpolator)

            let length = (base / 2.0) + ((1.0 - Math.ease(curve: .out, value: interpolator)) * (base / 2.0))

            let current = (lhs: (point + (-perpendicular * length)),
                           curve: point,
                           rhs: (point + (perpendicular * length)))
            
            let lhs = (vertices: [sweep.curve, sweep.lhs, current.lhs, current.curve], uvs: [uv1, peakUV, baseUV, uv2])
            let rhs = (vertices: [sweep.rhs, sweep.curve, current.curve, current.rhs], uvs: [peakUV, uv0, uv3, baseUV])
            
            polygons.append(contentsOf: face(vertices: lhs.vertices, uvs: lhs.uvs, side: .left))
            polygons.append(contentsOf: face(vertices: rhs.vertices, uvs: rhs.uvs, side: .right))
            
            if segment == 1 {

                let v0 = Vector(sweep.lhs.x, Constants.floor, sweep.lhs.z)
                let v1 = Vector(sweep.rhs.x, Constants.floor, sweep.rhs.z)
                let v2 = v0.lerp(v1, 0.5)

                guard let leftFace = polygon(vectors: [sweep.lhs, sweep.curve, v2, v0], uvs: lhs.uvs),
                      let rightFace = polygon(vectors: [sweep.curve, sweep.rhs, v1, v2], uvs: lhs.uvs) else { continue }

                polygons.append(contentsOf: [leftFace, rightFace])
            }
            
            if segment == segments {
                
                let v0 = Vector(current.lhs.x, Constants.floor, current.lhs.z)
                let v1 = Vector(current.rhs.x, Constants.floor, current.rhs.z)
                let v2 = v0.lerp(v1, 0.5)
                
                guard let leftFace = polygon(vectors: [current.curve, current.lhs, v0, v2], uvs: lhs.uvs),
                      let rightFace = polygon(vectors: [current.rhs, current.curve, v2, v1], uvs: lhs.uvs) else { continue }
                
                polygons.append(contentsOf: [leftFace, rightFace])
            }

            sweep = current
        }
        
        return polygons
    }
}

extension TrunkLeg {
    
    enum Side {
        
        case left
        case right
    }
    
    func face(vertices: [Euclid.Vector], uvs: [Euclid.Vector], side: Side) -> [Euclid.Polygon] {
        
        guard vertices.count == uvs.count else { return [] }
        
        let lowerVertices = vertices.reversed().map { Vector($0.x, Constants.floor, $0.z) }
        
        let faces = (upper: (vertices: vertices, uvs: uvs, center: vertices.average()),
                     lower: (vertices: lowerVertices, uvs: uvs, center: lowerVertices.average()))
        
        let edgeVertices = side == .left ? [faces.lower.vertices[2],
                                            faces.lower.vertices[1],
                                            faces.upper.vertices[2],
                                            faces.upper.vertices[1]] :
                                            [faces.upper.vertices[0],
                                             faces.upper.vertices[3],
                                             faces.lower.vertices[0],
                                             faces.lower.vertices[3]]
        
        guard let upperFace = polygon(vectors: faces.upper.vertices, uvs: faces.upper.uvs),
              let lowerFace = polygon(vectors: faces.lower.vertices, uvs: faces.lower.uvs),
              let edgeFace = polygon(vectors: edgeVertices, uvs: faces.upper.uvs) else { return [] }
        
        return [upperFace, lowerFace, edgeFace]
    }
}
