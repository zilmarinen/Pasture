//
//  StoneBridgeEdge.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct StoneBridgeEdge: Prop {
    
    let side: BridgeEdge.Side
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        
        var wallCorners = Ordinal.Coordinates.map { position + (size * Vector(Double($0.x), 0, Double($0.z))) }
        
        let cardinal = Cardinal.north
        let (o0, o1) = cardinal.ordinals
        let (o2, o3) = cardinal.opposite.ordinals
        let normal = cardinal.normal
        
        wallCorners[o0.rawValue] = wallCorners[o0.rawValue] + (-normal * StoneBridgeWall.Constants.inset)
        wallCorners[o1.rawValue] = wallCorners[o1.rawValue] + (-normal * StoneBridgeWall.Constants.inset)
        
        wallCorners[o2.rawValue] = wallCorners[o1.rawValue] + (-normal * StoneBridgeWall.Constants.thickness)
        wallCorners[o3.rawValue] = wallCorners[o0.rawValue] + (-normal * StoneBridgeWall.Constants.thickness)
        
        let middleCorners = wallCorners.map { $0 + Vector(0, StoneBridgeCorner.Constants.height, 0) }
        let upperCorners = wallCorners.map { $0 + Vector(0, StoneBridgeWall.Constants.height, 0) }
        
        let path = Mesh(StoneBridgePath(cardinals: [cardinal]).build(position: position))
        
        var v0 = middleCorners[o0.rawValue]
        var v1 = upperCorners[o1.rawValue]
        var v2 = upperCorners[o2.rawValue]
        var v3 = middleCorners[o3.rawValue]
        
        if side == .right {
            
            v0 = upperCorners[o0.rawValue]
            v1 = middleCorners[o1.rawValue]
            v2 = middleCorners[o2.rawValue]
            v3 = upperCorners[o3.rawValue]
        }
        
        guard let top = polygon(vectors: [v3, v2, v1, v0], uvs: wallTextureCoordinates.uvs),
              let front = polygon(vectors: [wallCorners[o3.rawValue], wallCorners[o2.rawValue], v2, v3], uvs: wallTextureCoordinates.uvs),
              let back = polygon(vectors: [v0, v1, wallCorners[o1.rawValue], wallCorners[o0.rawValue]], uvs: wallTextureCoordinates.uvs) else { return path.polygons }
        
        let wall = Mesh([top, front, back])
        
        return path.union(wall).polygons
    }
}
