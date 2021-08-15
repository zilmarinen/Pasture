//
//  SpruceTree.swift
//
//  Created by Zack Brown on 02/08/2021.
//

import Euclid
import Foundation
import Meadow
import SwiftUI

class SpruceTree: Codable, Hashable, ObservableObject {
    
    static let `default`: SpruceTree = SpruceTree(foliage: .default,
                                                  trunk: TreeTrunk(stump: .spruce,
                                                                   trunk: .spruce))
    
    enum CodingKeys: CodingKey {
        
        case foliage
        case trunk
    }
    
    @Published var foliage: SpruceTreeFoliage
    @Published var trunk: TreeTrunk
    
    init(foliage: SpruceTreeFoliage,
         trunk: TreeTrunk) {
        
        self.foliage = foliage
        self.trunk = trunk
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliage = try container.decode(SpruceTreeFoliage.self, forKey: .foliage)
        trunk = try container.decode(TreeTrunk.self, forKey: .trunk)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(foliage, forKey: .foliage)
        try container.encode(trunk, forKey: .trunk)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(foliage)
        hasher.combine(trunk)
    }
    
    static func == (lhs: SpruceTree, rhs: SpruceTree) -> Bool {
        
        return  lhs.foliage == rhs.foliage &&
                lhs.trunk == rhs.trunk
    }
}

extension SpruceTree: Prop {
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        guard let plane = Plane(normal: .up, pointOnPlane: .zero) else { return [] }
        
        let uvs = [Vector(0, 0, 0),
                   Vector(0, 0.5, 0),
                   Vector(1, 0.5, 0),
                   Vector(1, 0, 0)]
        
        let (uv0, uv1, uv2, uv3) = (uvs[0], uvs[1], uvs[2], uvs[3])
        
        //
        /// Create trunk
        //
        
        let t = trunk.build(position: position, plane: plane)
        
        //
        /// Create foliage
        //
        
        let totalSegments = foliage.turns * foliage.segments
        let step = 1.0 / Double(totalSegments)
        let rotation = Euclid.Angle(radians: Math.pi2 / Double(foliage.segments))
        let leafHeight = (foliage.height / (Double(foliage.turns) / 2.0))
        let peak = t.position + Vector(0, leafHeight / 2.0, 0)
        
        var polygons: [Euclid.Polygon] = []
        
        for turn in 0..<foliage.turns {
            
            let offset = turn * foliage.segments
            
            for segment in 0..<foliage.segments {
                
                let a0 = rotation * Double(segment)
                let a1 = rotation * Double(segment + 1)
                let index = offset + segment
                let i0 = (step * Double(index))
                let i1 = step * Double(index + 1)
                
                var v0 = peak + plot(radians: a0.radians, radius: (foliage.radius * i0))
                var v1 = peak + plot(radians: a1.radians, radius: (foliage.radius * i1))
                var v2 = peak + plot(radians: a1.radians, radius: (foliage.radius * i1) + foliage.thickness)
                var v3 = peak + plot(radians: a0.radians, radius: (foliage.radius * i0) + foliage.thickness)
                
                v0.y = peak.y - (foliage.height * i0)
                v1.y = peak.y - (foliage.height * i1)
                v2.y = v1.y
                v3.y = v0.y
                
                var v4 = v0
                var v5 = v1
                var v6 = v2
                var v7 = v3
                
                v4.y = max(v4.y - leafHeight, t.position.y - foliage.height)
                v5.y = max(v5.y - leafHeight, t.position.y - foliage.height)
                v6.y = max(v6.y - leafHeight, t.position.y - foliage.height)
                v7.y = max(v7.y - leafHeight, t.position.y - foliage.height)
                
                guard let a0 = polygon(vectors: [v3, v2, v1], uvs: [uv3, uv2, uv1]),
                      let a1 = polygon(vectors: [v3, v1, v0], uvs: [uv3, uv1, uv0]),
                      let b0 = polygon(vectors: [v4, v5, v6], uvs: [uv3, uv2, uv1]),
                      let b1 = polygon(vectors: [v4, v6, v7], uvs: [uv3, uv1, uv0]),
                      let front = polygon(vectors: [v7, v6, v2, v3], uvs: uvs),
                      let back = polygon(vectors: [v0, v1, v5, v4], uvs: uvs) else { continue }
                
                polygons.append(contentsOf: [a0, a1, b0, b1, front, back])
                
                if index == 0 {
                    
                    guard let edge = polygon(vectors: [v4, v7, v3, v0], uvs: uvs) else { continue }
                    
                    polygons.append(edge)
                }
                
                if index == (totalSegments - 1) {
                    
                    guard let edge = polygon(vectors: [v1, v2, v6, v5], uvs: uvs) else { continue }
                    
                    polygons.append(edge)
                }
            }
        }
        
        return Mesh(t.polygons).merge(Mesh(polygons)).polygons
    }
}
