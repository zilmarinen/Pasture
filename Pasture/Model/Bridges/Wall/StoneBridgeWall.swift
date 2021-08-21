//
//  StoneBridgeWall.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct StoneBridgeWall: Prop {
    
    enum Constants {
        
        static let height = World.Constants.slope * 2
        static let inset = World.Constants.slope / 4.0
        static let thickness = World.Constants.slope / 2.0
    }
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        
        var wallCorners = Ordinal.Coordinates.map { position + (size * Vector(Double($0.x), 0, Double($0.z))) }
        
        let cardinal = Cardinal.north
        let (o0, o1) = cardinal.ordinals
        let (o2, o3) = cardinal.opposite.ordinals
        let normal = cardinal.normal
        
        wallCorners[o0.rawValue] = wallCorners[o0.rawValue] + (-normal * Constants.inset)
        wallCorners[o1.rawValue] = wallCorners[o1.rawValue] + (-normal * Constants.inset)
        
        wallCorners[o2.rawValue] = wallCorners[o1.rawValue] + (-normal * Constants.thickness)
        wallCorners[o3.rawValue] = wallCorners[o0.rawValue] + (-normal * Constants.thickness)
        
        let upperCorners = wallCorners.map { $0 + Vector(0, Constants.height, 0) }
        
        let uvs = [Vector(wallTextureCoordinates.end.x, wallTextureCoordinates.start.y),
                   Vector(wallTextureCoordinates.start.x, wallTextureCoordinates.start.y),
                   Vector(wallTextureCoordinates.start.x, wallTextureCoordinates.end.y),
                   Vector(wallTextureCoordinates.end.x, wallTextureCoordinates.end.y)]
        
        var polygons: [Euclid.Polygon] = []
        
        for cardinal in [Cardinal.north, Cardinal.south] {
            
            let (o0, o1) = cardinal.ordinals
            
            let v0 = upperCorners[o0.rawValue]
            let v1 = upperCorners[o1.rawValue]
            let v2 = wallCorners[o1.rawValue]
            let v3 = wallCorners[o0.rawValue]
            
            guard let polygon = polygon(vectors: [v0, v1, v2, v3], uvs: uvs) else { continue }
            
            polygons.append(polygon)
        }
        
        let path = Mesh(StoneBridgePath(cardinals: [cardinal]).build(position: position))
        
        guard let polygon = polygon(vectors: upperCorners.reversed(), uvs: wallTextureCoordinates.uvs) else { return path.polygons }
        
        let wall = Mesh(polygons + [polygon])
        
        return path.union(wall).polygons
    }
}
