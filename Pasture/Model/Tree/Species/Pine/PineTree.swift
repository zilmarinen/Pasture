//
//  PineTree.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import Euclid
import Foundation
import Meadow
import SwiftUI

class PineTree: Codable, Hashable, ObservableObject {
    
    static let `default`: PineTree = PineTree(foliage: .default,
                                              trunk: .default)
    
    enum CodingKeys: CodingKey {
        
        case foliage
        case trunk
    }
    
    @Published var foliage: PineTreeFoliage
    @Published var trunk: TreeTrunk
    
    init(foliage: PineTreeFoliage,
         trunk: TreeTrunk) {
        
        self.foliage = foliage
        self.trunk = trunk
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliage = try container.decode(PineTreeFoliage.self, forKey: .foliage)
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
    
    static func == (lhs: PineTree, rhs: PineTree) -> Bool {
        
        return  lhs.foliage == rhs.foliage &&
                lhs.trunk == rhs.trunk
    }
}

extension PineTree: Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        guard let plane = Plane(normal: .up, pointOnPlane: .zero) else { return [] }
        
        let foliageUVs = UVs(start: Vector(x: 0, y: 0, z: 0), end: Vector(x: 1, y: 0.5, z: 0))
        
        //
        /// Create trunk
        //
        
        let t = trunk.build(position: position, plane: plane)
        
        var mesh = Mesh(t.polygons)
        
        //
        /// Create foliage
        //
        
        let rotation = Euclid.Angle(radians: Math.pi2 / Double(foliage.segments * 2))
        
        let height = foliage.height / Double(foliage.slices)
        var center = t.position + (plane.normal * (height / 3))
        
        for slice in 0..<foliage.slices {
        
            let interpolator = (1.0 / Double(foliage.slices)) * Double(slice)
            
            let peakRadius = (slice < foliage.slices - 1 ? foliage.peakRadius * Math.ease(curve: .inOut, value: (1.0 - interpolator)) : 0)
            let baseRadius = foliage.baseRadius * Math.ease(curve: .out, value: (1.0 - interpolator))
            
            let ring = FoliageRing(plane: t.plane, height: height, flop: foliage.flop, peakRadius: peakRadius, baseRadius: baseRadius, segments: foliage.segments, textureCoordinates: foliageUVs)
            
            var ringMesh = Mesh(ring.build(position: center))
            
            if slice % 2 == 0 {
                
                ringMesh = ringMesh.rotated(by: .yaw(rotation))
            }
            
            mesh = mesh.union(ringMesh)
            
            center = center + (ring.peakCenter * (1.0 + height))
        }
        
        return mesh.polygons
    }
}
