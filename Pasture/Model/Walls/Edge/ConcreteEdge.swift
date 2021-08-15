//
//  ConcreteEdge.swift
//
//  Created by Zack Brown on 10/08/2021.
//

import Euclid
import Foundation
import Meadow

struct ConcreteEdge: Prop {
    
    enum Constants {
        
        static let columnHeight = World.Constants.slope * 4
        static let wallHeight = World.Constants.slope * 2
        static let inset = World.Constants.slope
    }
    
    let side: Edge.Side
    let external: Bool
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        let roofTextureCoordinates = UVs(start: .zero, end: Vector(0.5, 0.5))
        
        var lowerCorners = Ordinal.Coordinates.map { position + (size * Vector(Double($0.x), 0, Double($0.z))) }
        
        let cardinal = side == .left ? Cardinal.east : .west
        
        let (o0, o1) = cardinal.ordinals
        let (o2, o3) = cardinal.opposite.ordinals
        let normal = cardinal.normal
        
        lowerCorners[o2.rawValue] = lowerCorners[o2.rawValue] + (normal * Constants.inset)
        lowerCorners[o3.rawValue] = lowerCorners[o3.rawValue] + (normal * Constants.inset)
        
        if !external {
            
            lowerCorners[o0.rawValue] = lowerCorners[o0.rawValue] + (-normal * Constants.inset)
            lowerCorners[o1.rawValue] = lowerCorners[o1.rawValue] + (-normal * Constants.inset)
        }
        
        let upperCorners = lowerCorners.map { $0 + Vector(0, Constants.columnHeight, 0) }
        let middleCorners = lowerCorners.map { $0 + Vector(0, Constants.wallHeight, 0) }
        
        let uvs = [Vector(wallTextureCoordinates.end.x, wallTextureCoordinates.start.y),
                   Vector(wallTextureCoordinates.start.x, wallTextureCoordinates.start.y),
                   Vector(wallTextureCoordinates.start.x, wallTextureCoordinates.end.y),
                   Vector(wallTextureCoordinates.end.x, wallTextureCoordinates.end.y)]
        
        let v0 = upperCorners[o0.rawValue].lerp(upperCorners[o1.rawValue], 0.5)
        let v1 = upperCorners[o3.rawValue].lerp(upperCorners[o2.rawValue], 0.5)
        let v2 = middleCorners[o0.rawValue].lerp(middleCorners[o1.rawValue], 0.5)
        let v3 = middleCorners[o3.rawValue].lerp(middleCorners[o2.rawValue], 0.5)
        let v4 = lowerCorners[o0.rawValue].lerp(lowerCorners[o1.rawValue], 0.5)
        let v5 = lowerCorners[o3.rawValue].lerp(lowerCorners[o2.rawValue], 0.5)
        
        switch side {
            
        case .left:
            
            guard let ulhs = polygon(vectors: [upperCorners[o3.rawValue], v1, v0, upperCorners[o0.rawValue]], uvs: roofTextureCoordinates.uvs),
                  let urhs = polygon(vectors: [v3, middleCorners[o2.rawValue], middleCorners[o1.rawValue], v2], uvs: roofTextureCoordinates.uvs),
                  let flhs = polygon(vectors: [lowerCorners[o3.rawValue], v5, v1, upperCorners[o3.rawValue]], uvs: uvs),
                  let frhs = polygon(vectors: [v5, lowerCorners[o2.rawValue], middleCorners[o2.rawValue], v3], uvs: uvs),
                  let blhs = polygon(vectors: [upperCorners[o0.rawValue], v0, v4, lowerCorners[o0.rawValue]], uvs: uvs),
                  let brhs = polygon(vectors: [v2, middleCorners[o1.rawValue], lowerCorners[o1.rawValue], v4], uvs: uvs),
                  let face = polygon(vectors: [v0, v1, v3, v2], uvs: roofTextureCoordinates.uvs) else { return [] }
            
            return [ulhs, urhs, flhs, frhs, blhs, brhs, face]
        
        case .right:
            
            guard let ulhs = polygon(vectors: [middleCorners[o3.rawValue], v3, v2, middleCorners[o0.rawValue]], uvs: roofTextureCoordinates.uvs),
                  let urhs = polygon(vectors: [v1, upperCorners[o2.rawValue], upperCorners[o1.rawValue], v0], uvs: roofTextureCoordinates.uvs),
                  let flhs = polygon(vectors: [lowerCorners[o3.rawValue], v5, v3, middleCorners[o3.rawValue]], uvs: uvs),
                  let frhs = polygon(vectors: [v5, lowerCorners[o2.rawValue], upperCorners[o2.rawValue], v1], uvs: uvs),
                  let blhs = polygon(vectors: [middleCorners[o0.rawValue], v2, v4, lowerCorners[o0.rawValue]], uvs: uvs),
                  let brhs = polygon(vectors: [v0, upperCorners[o1.rawValue], lowerCorners[o1.rawValue], v4], uvs: uvs),
                  let face = polygon(vectors: [v2, v3, v1, v0], uvs: roofTextureCoordinates.uvs) else { return [] }
            
            return [ulhs, urhs, flhs, frhs, blhs, brhs, face]
        }
    }
}
