//
//  StoneBridgeCorner.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct StoneBridgeCorner: Prop {
    
    enum Constants {
        
        static let height = World.Constants.slope
    }
    
    let side: BridgeEdge.Side
    
    let cardinals: [Cardinal]
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        
        var wallCorners = Ordinal.Coordinates.map { position + (size * Vector(Double($0.x), 0, Double($0.z))) }
        
        let path = Mesh(StoneBridgePath(cardinals: cardinals).build(position: position))
        
        switch cardinals.count {
            
        case 1:
            
            guard let cardinal = cardinals.first else { return path.polygons }
            
            let (c0, c1) = cardinal.cardinals
            let (o0, o1) = cardinal.ordinals
            let (o2, o3) = cardinal.opposite.ordinals
            let normal = cardinal.normal
            
            wallCorners[o0.rawValue] = wallCorners[o0.rawValue] + (-normal * StoneBridgeWall.Constants.inset)
            wallCorners[o1.rawValue] = wallCorners[o1.rawValue] + (-normal * StoneBridgeWall.Constants.inset)
            
            wallCorners[o2.rawValue] = wallCorners[o1.rawValue] + (-normal * StoneBridgeWall.Constants.thickness)
            wallCorners[o3.rawValue] = wallCorners[o0.rawValue] + (-normal * StoneBridgeWall.Constants.thickness)
            
            switch side {
                
            case .left:
                
                let edgeNormal = c1.normal
                
                wallCorners[o0.rawValue] = wallCorners[o0.rawValue] + (edgeNormal * StoneBridgeWall.Constants.thickness)
                wallCorners[o3.rawValue] = wallCorners[o3.rawValue] + (edgeNormal * StoneBridgeWall.Constants.thickness)
                
            default:
                
                let edgeNormal = c0.normal
                
                wallCorners[o1.rawValue] = wallCorners[o1.rawValue] + (edgeNormal * StoneBridgeWall.Constants.thickness)
                wallCorners[o2.rawValue] = wallCorners[o2.rawValue] + (edgeNormal * StoneBridgeWall.Constants.thickness)
            }
            
            let upperCorners = wallCorners.map { $0 + Vector(0, Constants.height, 0) }
            
            guard let top = polygon(vectors: upperCorners.reversed(), uvs: wallTextureCoordinates.uvs),
                  let front = polygon(vectors: [wallCorners[o3.rawValue], wallCorners[o2.rawValue], upperCorners[o2.rawValue], upperCorners[o3.rawValue]], uvs: wallTextureCoordinates.uvs),
                  let back = polygon(vectors: [upperCorners[o0.rawValue], upperCorners[o1.rawValue], wallCorners[o1.rawValue], wallCorners[o0.rawValue]], uvs: wallTextureCoordinates.uvs),
                  let lhs = polygon(vectors: [wallCorners[o0.rawValue], wallCorners[o3.rawValue], upperCorners[o3.rawValue], upperCorners[o0.rawValue]], uvs: wallTextureCoordinates.uvs),
                  let rhs = polygon(vectors: [wallCorners[o2.rawValue], wallCorners[o1.rawValue], upperCorners[o1.rawValue], upperCorners[o2.rawValue]], uvs: wallTextureCoordinates.uvs) else { return path.polygons }
            
            let wall = Mesh([top, front, back, lhs, rhs])
            
            return path.union(wall).polygons
            
        default:
            
            guard let c0 = cardinals.first,
                  let c1 = cardinals.last else { return path.polygons }
            
            for cardinal in cardinals {
                
                let (o0, o1) = cardinal.ordinals
                let normal = cardinal.normal
                
                wallCorners[o0.rawValue] = wallCorners[o0.rawValue] + (-normal * StoneBridgeWall.Constants.inset)
                wallCorners[o1.rawValue] = wallCorners[o1.rawValue] + (-normal * StoneBridgeWall.Constants.inset)
            }
            
            let (o0, o1) = c0.ordinals
            let (_, o3) = c1.ordinals
            
            let v0 = wallCorners[o0.rawValue]
            let v1 = wallCorners[o1.rawValue]
            let v2 = wallCorners[o3.rawValue]
            let v3 = v2 + (-c1.normal * StoneBridgeWall.Constants.thickness)
            let v4 = v1 + (-c0.normal * StoneBridgeWall.Constants.thickness) + (-c1.normal * StoneBridgeWall.Constants.thickness)
            let v5 = v0 + (-c0.normal * StoneBridgeWall.Constants.thickness)
            
            let height = Vector(0, Constants.height, 0)
            
            let (v6, v7, v8, v9, v10, v11) = (v0 + height, v1 + height, v2 + height, v3 + height, v4 + height, v5 + height)
            
            guard let tlhs = polygon(vectors: [v11, v10, v7, v6], uvs: wallTextureCoordinates.uvs),
                  let trhs = polygon(vectors: [v10, v9, v8, v7], uvs: wallTextureCoordinates.uvs),
                  let ilhs = polygon(vectors: [v5, v4, v10, v11], uvs: wallTextureCoordinates.uvs),
                  let irhs = polygon(vectors: [v4, v3, v9, v10], uvs: wallTextureCoordinates.uvs),
                  let olhs = polygon(vectors: [v6, v7, v1, v0], uvs: wallTextureCoordinates.uvs),
                  let orhs = polygon(vectors: [v7, v8, v2, v1], uvs: wallTextureCoordinates.uvs) else { return path.polygons }
            
            let wall = Mesh([tlhs, trhs, ilhs, irhs, olhs, orhs])
            
            return path.union(wall).polygons
        }
    }
}
