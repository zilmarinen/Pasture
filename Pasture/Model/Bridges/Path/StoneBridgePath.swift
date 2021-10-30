//
//  StoneBridgePath.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct StoneBridgePath: Prop {
    
    enum Constants {
        
        static let depth = World.Constants.slope
    }
    
    let cardinals: [Cardinal]
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let floorTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        
        let corners = Ordinal.Coordinates.map { position + Vector(0, 0.001, 0) + (size * Vector(Double($0.x), 0, Double($0.z))) }
        
        guard let face = polygon(vectors: corners.reversed(), uvs: floorTextureCoordinates.corners) else { return [] }
        
        var polygons = [face]
        
        for cardinal in cardinals {
            
            let (o0, o1) = cardinal.ordinals
            
            let v0 = corners[o0.rawValue]
            let v1 = corners[o1.rawValue]
            let v2 = corners[o1.rawValue] - Vector(0, Constants.depth, 0)
            let v3 = corners[o0.rawValue] - Vector(0, Constants.depth, 0)
            
            guard let face = polygon(vectors: [v0, v1, v2, v3], uvs: wallTextureCoordinates.corners) else { continue }
            
            polygons.append(face)
        }
        
        return polygons
    }
}
