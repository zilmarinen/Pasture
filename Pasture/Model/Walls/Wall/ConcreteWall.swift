//
//  ConcreteWall.swift
//
//  Created by Zack Brown on 10/08/2021.
//

import Euclid
import Foundation
import Meadow

struct ConcreteWall: Prop {
    
    enum Constants {
        
        static let height = World.Constants.slope * 2
        static let inset = World.Constants.slope
    }
    
    let external: Bool
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        let roofTextureCoordinates = UVs(start: .zero, end: Vector(0.5, 0.5))
        
        var lowerCorners = Ordinal.Coordinates.map { position + (size * Vector(Double($0.x), 0, Double($0.z))) }
        
        let (o0, o1) = Cardinal.north.ordinals
        let (o2, o3) = Cardinal.south.ordinals
        let normal = Cardinal.north.normal
        
        lowerCorners[o2.rawValue] = lowerCorners[o2.rawValue] + (normal * Constants.inset)
        lowerCorners[o3.rawValue] = lowerCorners[o3.rawValue] + (normal * Constants.inset)
        
        if !external {
            
            lowerCorners[o0.rawValue] = lowerCorners[o0.rawValue] + (-normal * Constants.inset)
            lowerCorners[o1.rawValue] = lowerCorners[o1.rawValue] + (-normal * Constants.inset)
        }
        
        let upperCorners = lowerCorners.map { $0 + Vector(0, Constants.height, 0) }
        
        let uvs = [Vector(wallTextureCoordinates.end.x, wallTextureCoordinates.start.y),
                   Vector(wallTextureCoordinates.start.x, wallTextureCoordinates.start.y),
                   Vector(wallTextureCoordinates.start.x, wallTextureCoordinates.end.y),
                   Vector(wallTextureCoordinates.end.x, wallTextureCoordinates.end.y)]
        
        var polygons: [Euclid.Polygon] = []
        
        for cardinal in [Cardinal.north, Cardinal.south] {
            
            let (o0, o1) = cardinal.ordinals
            
            let v0 = upperCorners[o0.rawValue]
            let v1 = upperCorners[o1.rawValue]
            let v2 = lowerCorners[o1.rawValue]
            let v3 = lowerCorners[o0.rawValue]
            
            guard let polygon = polygon(vectors: [v0, v1, v2, v3], uvs: uvs) else { continue }
            
            polygons.append(polygon)
        }
        
        guard let polygon = polygon(vectors: upperCorners.reversed(), uvs: roofTextureCoordinates.corners) else { return polygons }
        
        return polygons + [polygon]
    }
}
