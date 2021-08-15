//
//  BuildingDoor.swift
//
//  Created by Zack Brown on 05/08/2021.
//

import Euclid
import Foundation
import Meadow

struct BuildingDoor: Prop {
    
    enum Constants {
        
        static let width = 0.75
        static let depth = 0.05
        static let height = World.Constants.slope * 3
    }
    
    let architecture: Building.Architecture
    
    let c0: Vector
    let c1: Vector
    
    let cardinal: Cardinal
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let borderTextureCoordinates = UVs(start: Vector(0.5, 0.375), end: Vector(1.0, 0.5))
        let doorTextureCoordinates = UVs(start: Vector(0.5, 0.125), end: Vector(1.0, 0.25))
        
        let outer = Mesh(shape(position: position, uvs: borderTextureCoordinates, width: Constants.width, depth: Constants.depth, height: Constants.height))
        let inner = Mesh(shape(position: position, uvs: borderTextureCoordinates, width: Constants.width - 0.1, depth: 0.07, height: Constants.height - 0.05))
        let door = Mesh(shape(position: position, uvs: doorTextureCoordinates, width: Constants.width - 0.1, depth: 0.06, height: Constants.height - 0.05))
        
        return outer.subtract(inner).union(door).polygons
    }
    
    func shape(position: Vector, uvs: UVs, width: Double, depth: Double, height: Double) -> [Euclid.Polygon] {
        
        let radius = width / 2.0
        let offset = (-cardinal.normal * depth)
        let v0 = position + (-offset / 2.0) + c0.lerp(c1, (1.0 - width) / 2.0)
        let v1 = position + (-offset / 2.0) + c1.lerp(c0, (1.0 - width) / 2.0)
        let v2 = v1 + Vector(0, height, 0)
        let v3 = v0 + Vector(0, height, 0)
        
        switch architecture.borderStyle {
            
        case .pointy:
            
            let v4 = v1 + Vector(0, height - ((v0 - v1).length / 4.0), 0)
            let v5 = v0 + Vector(0, height - ((v0 - v1).length / 4.0), 0)
            let p0 = v2.lerp(v3, 0.5)
            let puv = uvs.uvs[0].lerp(uvs.uvs[1], 0.5)
            
            let faceUVs = [uvs.uvs[0], puv, uvs.uvs[1], uvs.uvs[2], uvs.uvs[3]]
            
            let (v6, v7, v8, v9, p1) = (v0 + offset, v1 + offset, v4 + offset, v5 + offset, p0 + offset)
            
            guard let front = polygon(vectors: [v5, p0, v4, v1, v0], uvs: faceUVs),
                  let back = polygon(vectors: [v6, v7, v8, p1, v9], uvs: faceUVs),
                  let lhs = polygon(vectors: [v4, v8, v7, v1], uvs: uvs.uvs),
                  let rhs = polygon(vectors: [v0, v6, v9, v5], uvs: uvs.uvs),
                  let tlhs = polygon(vectors: [p0, p1, v8, v4], uvs: uvs.uvs),
                  let trhs = polygon(vectors: [v9, p1, p0, v5], uvs: uvs.uvs),
                  let bottom = polygon(vectors: [v0, v1, v7, v6], uvs: uvs.uvs) else { return [] }
            
            return [front, back, lhs, rhs, tlhs, trhs, bottom]
            
        case .rounded:
            
            let segments = 10
            let rotation = Angle(radians: Double.pi / Double(segments))
            let needsFlipping = cardinal == .north || cardinal == .east
            
            let v4 = v1 + Vector(0, height - (radius / 2.0), 0)
            let v5 = v0 + Vector(0, height - (radius / 2.0), 0)
            let p1 = v4.lerp(v5, 0.5)
            
            let (v6, v7, v8, v9) = (v0 + offset, v1 + offset, v4 + offset, v5 + offset)
            
            var frontFace = needsFlipping ? [v4, v1, v0] : [v5, v0, v1]
            var backFace = needsFlipping ? [v8, v7, v6] : [v9, v6, v7]
            var topFaces: [Euclid.Polygon] = []
            
            let uvRadius = (uvs.end.x - uvs.start.x) / 2.0
            let uv0 = uvs.uvs[0].lerp(uvs.uvs[3], 0.5)
            let uv1 = uvs.uvs[1].lerp(uvs.uvs[2], 0.5)
            let puv = uv0.lerp(uv1, 0.5)
            var faceUVs = [uv1, uvs.uvs[2], uvs.uvs[3]]
            
            var sweep: Vector? = nil
            
            for segment in 0..<segments {
                
                let angle = rotation * Double(segment)
                
                let p2 = plot(radians: angle.radians - (Double.pi / 2.0), radius: (v4 - v5).length / 2.0)
                let p3 = cardinal == .north || cardinal == .south ? Vector(p2.x, p2.z, 0) : Vector(0, p2.z, p2.x)
                
                let uvp = plot(radians: angle.radians - (Double.pi / 2.0), radius: uvRadius)
                
                frontFace.append(p1 + p3)
                backFace.append(p1 + offset + p3)
                faceUVs.append(puv + uvp)
                
                if let sweep = sweep {
                    
                    let face = needsFlipping ? [sweep + offset, p1 + offset + p3, p1 + p3, sweep] : [sweep, p1 + p3, p1 + offset + p3, sweep + offset]
                    
                    guard let polygon = polygon(vectors: face, uvs: uvs.uvs) else { break }
                    
                    topFaces.append(polygon)
                }
                
                sweep = p1 + p3
            }
            
            if let sweep = sweep {
                
                let face = needsFlipping ? [sweep + offset, v8, v4, sweep] : [sweep, v5, v9, sweep + offset]
                
                if let polygon = polygon(vectors: face, uvs: uvs.uvs) {
                
                    topFaces.append(polygon)
                }
            }
            
            guard let front = polygon(vectors: needsFlipping ? frontFace : frontFace.reversed(), uvs: faceUVs),
                  let back = polygon(vectors: needsFlipping ? backFace.reversed() : backFace, uvs: faceUVs),
                  let lhs = polygon(vectors: [v4, v8, v7, v1], uvs: uvs.uvs),
                  let rhs = polygon(vectors: [v0, v6, v9, v5], uvs: uvs.uvs),
                  let bottom = polygon(vectors: [v0, v1, v7, v6], uvs: uvs.uvs) else { return [] }
            
            return [front, back, lhs, rhs, bottom] + topFaces
            
        case .square:
            
            let (v4, v5, v6, v7) = (v0 + offset, v1 + offset, v2 + offset, v3 + offset)
            
            guard let front = polygon(vectors: [v3, v2, v1, v0], uvs: uvs.uvs),
                  let back = polygon(vectors: [v4, v5, v6, v7], uvs: uvs.uvs),
                  let lhs = polygon(vectors: [v2, v6, v5, v1], uvs: uvs.uvs),
                  let rhs = polygon(vectors: [v0, v4, v7, v3], uvs: uvs.uvs),
                  let top = polygon(vectors: [v3, v7, v6, v2], uvs: uvs.uvs),
                  let bottom = polygon(vectors: [v0, v1, v5, v4], uvs: uvs.uvs) else { return [] }
            
            return [front, back, lhs, rhs, top, bottom]
        }
    }
}
