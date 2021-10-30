//
//  PicketCorner.swift
//
//  Created by Zack Brown on 13/08/2021.
//

import Euclid
import Foundation
import Meadow

struct PicketCorner: Prop {
    
    enum Constants {
        
        static let postHeight = World.Constants.slope * 1.4
    }
    
    let cardinals: [Cardinal]
 
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let beamTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        let postTextureCoordinates = UVs(start: .zero, end: Vector(0.5, 0.5))
        
        let corners = Ordinal.Coordinates.map { position + (size * Vector(Double($0.x), 0, Double($0.z))) }
        
        let step = 1.0 / Double(PicketWall.Constants.pickets)
        
        var mesh = Mesh(post(position: position, uvs: postTextureCoordinates))
        
        var v0 = position
        var v1 = position
        
        for edge in cardinals {
            
            var normal = Vector.zero
            var cardinal = edge
            
            switch edge {
                
            case .north,
                    .south:
                
                cardinal = Cardinal.east
                let (o0, o1) = cardinal.ordinals
                let (o2, o3) = cardinal.opposite.ordinals
                normal = cardinal.normal
                
                v0 = edge == .north ? corners[o0.rawValue].lerp(corners[o3.rawValue], 0.5) : position
                v1 = edge == .south ? corners[o1.rawValue].lerp(corners[o2.rawValue], 0.5) : position
                
            default:
                
                cardinal = Cardinal.north
                let (o0, o1) = cardinal.ordinals
                let (o2, o3) = cardinal.opposite.ordinals
                normal = cardinal.normal
                
                v0 = edge == .west ? corners[o0.rawValue].lerp(corners[o3.rawValue], 0.5) : position
                v1 = edge == .east ? corners[o1.rawValue].lerp(corners[o2.rawValue], 0.5) : position
            }
            
            let c0 = v0 + (-normal * (PicketWall.Constants.picketThickness / 2.0))
            let c1 = v1 + (-normal * (PicketWall.Constants.picketThickness / 2.0))
            let c2 = v0 + (normal * (PicketWall.Constants.picketThickness / 2.0))
            let c3 = v1 + (normal * (PicketWall.Constants.picketThickness / 2.0))
            
            for layer in [1, 3] {
                
                mesh = mesh.union(Mesh(beam(c0: c0, c1: c1, normal: normal, layer: layer, uvs: beamTextureCoordinates)))
            }
            
            for index in 0..<PicketWall.Constants.pickets - 1 {
                
                guard index % 2 == 0 else { continue }
                
                let v2 = c0.lerp(c1, (Double(index + (edge == .east || edge == .south ? 1 : 0)) + 0.5) * step)
                let v3 = c3.lerp(c2, (Double(index) - (edge == .east || edge == .south ? 1 : 0) + 1.5) * step)
                
                mesh = mesh.union(Mesh(picket(position: v2, cardinal: cardinal, uvs: postTextureCoordinates)))
                mesh = mesh.union(Mesh(picket(position: v3, cardinal: cardinal.opposite, uvs: postTextureCoordinates)))
            }
        }
        
        return mesh.polygons
    }
    
    func beam(c0: Vector, c1: Vector, normal: Vector, layer: Int, uvs: UVs) -> [Euclid.Polygon] {
        
        let offset = Vector(0, (PicketWall.Constants.height / 5) * Double(layer), 0)
        let height = Vector(0, PicketWall.Constants.beamThickness, 0)
        
        let v0 = c0 + offset
        let v1 = c1 + offset
        let v2 = v1 + (normal * PicketWall.Constants.beamThickness)
        let v3 = v0 + (normal * PicketWall.Constants.beamThickness)
        
        let (v4, v5, v6, v7) = (v0 + height, v1 + height, v2 + height, v3 + height)
        
        guard let top = polygon(vectors: [v4, v5, v6, v7], uvs: uvs.corners),
              let front = polygon(vectors: [v0, v1, v5, v4], uvs: uvs.corners),
              let back = polygon(vectors: [v2, v3, v7, v6], uvs: uvs.corners),
              let bottom = polygon(vectors: [v3, v2, v1, v0], uvs: uvs.corners),
              let lhs = polygon(vectors: [v4, v7, v3, v0], uvs: uvs.corners),
              let rhs = polygon(vectors: [v1, v2, v6, v5], uvs: uvs.corners) else { return [] }
        
        return [top, front, back, bottom, lhs, rhs]
    }
    
    func picket(position: Vector, cardinal: Cardinal, uvs: UVs) -> [Euclid.Polygon] {
        
        let peakHeight = Vector(0, PicketWall.Constants.height, 0)
        let cornerHeight = Vector(0, PicketWall.Constants.height - PicketWall.Constants.width, 0)
        
        let (_, c1) = cardinal.cardinals
        
        let v1 = position + (c1.normal * PicketWall.Constants.width)
        let v2 = v1 + (cardinal.opposite.normal * PicketWall.Constants.picketThickness)
        let v3 = position + (cardinal.opposite.normal * PicketWall.Constants.picketThickness)
        
        let (v4, v5, v6, v7) = (position + cornerHeight, v1 + cornerHeight, v2 + cornerHeight, v3 + cornerHeight)
        let (v8, v9) = (position.lerp(v1, 0.5) + peakHeight, v3.lerp(v2, 0.5) + peakHeight)
        
        let faceUVs = [uvs.corners[0], uvs.corners[0].lerp(uvs.corners[1], 0.5), uvs.corners[1], uvs.corners[2], uvs.corners[3]]
        
        guard let tlhs = polygon(vectors: [v7, v9, v8, v4], uvs: uvs.corners),
              let trhs = polygon(vectors: [v9, v6, v5, v8], uvs: uvs.corners),
              let lhs = polygon(vectors: [position, v3, v7, v4], uvs: uvs.corners),
              let rhs = polygon(vectors: [v5, v6, v2, v1], uvs: uvs.corners),
              let bottom = polygon(vectors: [position, v1, v2, v3], uvs: uvs.corners),
              let front = polygon(vectors: [v6, v9, v7, v3, v2], uvs: faceUVs),
              let back = polygon(vectors: [v4, v8, v5, v1, position], uvs: faceUVs) else { return [] }
        
        return [tlhs, trhs, lhs, rhs, bottom, front, back]
    }
    
    func post(position: Vector, uvs: UVs) -> [Euclid.Polygon] {
        
        let size = Vector(PicketWall.Constants.beamThickness, 0.0, PicketWall.Constants.beamThickness)
        
        let lowerCorners = Ordinal.Coordinates.map { position + (size * Vector(Double($0.x), 0, Double($0.z))) }
        let upperCorners = lowerCorners.map { $0 + Vector(0, Constants.postHeight, 0) }
        
        let faceUVs = [Vector(uvs.end.x, uvs.start.y),
                       Vector(uvs.start.x, uvs.start.y),
                       Vector(uvs.start.x, uvs.end.y),
                       Vector(uvs.end.x, uvs.end.y)]
        
        var polygons: [Euclid.Polygon] = []
        
        for cardinal in Cardinal.allCases {
            
            let (o0, o1) = cardinal.ordinals
            
            let v0 = upperCorners[o0.rawValue]
            let v1 = upperCorners[o1.rawValue]
            let v2 = lowerCorners[o1.rawValue]
            let v3 = lowerCorners[o0.rawValue]
            
            guard let polygon = polygon(vectors: [v0, v1, v2, v3], uvs: faceUVs) else { continue }
            
            polygons.append(polygon)
        }
        
        guard let top = polygon(vectors: upperCorners.reversed(), uvs: uvs.corners),
              let bottom = polygon(vectors: lowerCorners, uvs: uvs.corners) else { return polygons }
        
        return polygons + [top, bottom]
    }
}
