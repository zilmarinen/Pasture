//
//  PalmTree.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import Euclid
import Foundation
import Meadow
import SwiftUI

class PalmTree: Codable, Hashable, ObservableObject {
    
    enum CodingKeys: CodingKey {
        
        case foliage
        case trunk
    }
    
    static let `default`: PalmTree = PalmTree(foliage: .default, trunk: .default)
    
    @Published var foliage: PalmTreeFoliage
    @Published var trunk: PalmTreeTrunk
    
    init(foliage: PalmTreeFoliage,
         trunk: PalmTreeTrunk) {
        
        self.foliage = foliage
        self.trunk = trunk
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliage = try container.decode(PalmTreeFoliage.self, forKey: .foliage)
        trunk = try container.decode(PalmTreeTrunk.self, forKey: .trunk)
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
    
    static func == (lhs: PalmTree, rhs: PalmTree) -> Bool {
        
        return  lhs.foliage == rhs.foliage &&
                lhs.trunk == rhs.trunk
    }
}

extension PalmTree: Prop {
    
    func build() -> [Euclid.Polygon] {
        
        let frondUVs = UVs(start: Vector(x: 0, y: 0, z: 0), end: Vector(x: 1, y: 0.5, z: 0))
        let chonkUVs = UVs(start: Vector(x: 0, y: 0.5, z: 0), end: Vector(x: 1, y: 1, z: 0))
        
        //
        /// Create plam tree trunk and throne
        //
        
        guard let plane = Plane(normal: .up, pointOnPlane: .zero) else { return [] }
        
        var mesh = Euclid.Mesh([])
        
        let yStep = Double(1.0 / Double(trunk.slices))
        let segmentHeight = Double(((trunk.height / Double(trunk.slices))) - (trunk.segment.peak + trunk.segment.base))
        let randomX = Math.random(minimum: -1, maximum: 1)
        let randomZ = Math.random(minimum: -1, maximum: 1)
        let offset = Vector(randomX * trunk.spread, trunk.height, randomZ * trunk.spread)
        let control = Vector(0, trunk.height, 0)
         
        var node = Chonk(position: Vector(0, -trunk.throne.base, 0), plane: plane, peak: trunk.throne.peak, base: trunk.throne.base, height: segmentHeight, peakRadius: trunk.throne.peakRadius, baseRadius: trunk.throne.baseRadius, segments: trunk.throne.segments, textureCoordinates: chonkUVs)
        
        mesh = mesh.union(Mesh(node.build()))
        
        for slice in 0..<trunk.slices {
            
            let position = curve(start: node.peakCenter, end: offset, control: control, interpolator: Double(slice) * yStep + 1)
            
            guard let plane = Plane(normal: position.normalized(), pointOnPlane: .zero) else { continue }
            
            let segment = Chonk(position: node.peakCenter, plane: plane, peak: trunk.segment.peak, base: trunk.segment.base, height: segmentHeight, peakRadius: trunk.segment.peakRadius, baseRadius: trunk.segment.baseRadius, segments: trunk.segment.segments, textureCoordinates: chonkUVs)

            mesh = mesh.union(Mesh(segment.build()))

            node = segment
        }
        
        node = Chonk(position: node.peakCenter, plane: node.plane, peak: foliage.crown.peak, base: foliage.crown.base, height: (segmentHeight / 2.0), peakRadius: foliage.crown.peakRadius, baseRadius: foliage.crown.baseRadius, segments: foliage.crown.segments, textureCoordinates: chonkUVs)
        
        mesh = mesh.union(Mesh(node.build()))
        
        //
        /// Create palm tree leaves
        //
        
        let rotation = Euclid.Angle(radians: Math.pi2 / Double(foliage.fronds))
        
        for leaf in 0..<foliage.fronds {
            
            let angle = (rotation.radians * Double(leaf)) + Math.random(minimum: -foliage.frond.spread, maximum: foliage.frond.spread)
            
            let frond = Frond(position: node.peakCenter, plane: node.plane, angle: angle, radius: foliage.frond.radius, width: foliage.frond.width, spread: foliage.frond.spread, segments: foliage.frond.segments, textureCoordinates: frondUVs)
            
            //mesh = mesh.union(Mesh(frond.build()))
            mesh = mesh.merge(Mesh(frond.build()))
        }
        
        return mesh.polygons
    }
}
