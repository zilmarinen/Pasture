//
//  BuildingWall.swift
//
//  Created by Zack Brown on 16/07/2021.
//

import Euclid
import Foundation
import Meadow

struct BuildingWall: Prop {
    
    let c0: Euclid.Vector
    let c1: Euclid.Vector
    
    let height: Double
    
    let layer: Int
    
    let normal: Euclid.Vector
    
    let textureCoordinates: UVs
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        let floor = Vector(0, Double(layer) * height, 0)
        let ceiling = floor + Vector(0, height, 0)
      
        let v0 = c0 + ceiling
        let v1 = c1 + ceiling
        let v2 = c1 + floor
        let v3 = c0 + floor
        
        let vectors = [v0, v1, v2, v3].map { $0 + position }
        
        let uvs = [Vector(textureCoordinates.end.x, textureCoordinates.start.y),
                   Vector(textureCoordinates.start.x, textureCoordinates.start.y),
                   Vector(textureCoordinates.start.x, textureCoordinates.end.y),
                   Vector(textureCoordinates.end.x, textureCoordinates.end.y)]
        
        guard let polygon = polygon(vectors: vectors, uvs: uvs) else { return [] }
        
        return [polygon]
    }
}
