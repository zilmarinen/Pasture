//
//  TreeTrunk.swift
//
//  Created by Zack Brown on 01/07/2021.
//

import Euclid
import GameKit
import SwiftUI
import Meadow

class TreeTrunk: Codable, Hashable, ObservableObject {
    
    static let `default`: TreeTrunk = TreeTrunk(stump: .default,
                                                trunk: .default,
                                                noise: .default)
    
    enum CodingKeys: CodingKey {
        
        case stump
        case trunk
        case noise
    }
    
    @Published var stump: Stump
    @Published var trunk: Trunk
    @Published var noise: Noise
    
    init(stump: Stump,
         trunk: Trunk,
         noise: Noise) {
        
        self.stump = stump
        self.trunk = trunk
        self.noise = noise
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stump = try container.decode(Stump.self, forKey: .stump)
        trunk = try container.decode(Trunk.self, forKey: .trunk)
        noise = try container.decode(Noise.self, forKey: .noise)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(stump, forKey: .stump)
        try container.encode(trunk, forKey: .trunk)
        try container.encode(noise, forKey: .noise)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(stump)
        hasher.combine(trunk)
        hasher.combine(noise)
    }
    
    static func == (lhs: TreeTrunk, rhs: TreeTrunk) -> Bool {
        
        return  lhs.stump == rhs.stump &&
                lhs.trunk == rhs.trunk &&
                lhs.noise == rhs.noise
    }
}

extension TreeTrunk: Prop {
    
    typealias Builder = (polygons: [Euclid.Polygon], position: Euclid.Vector, plane: Euclid.Plane)
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] { return [] }
    
    func build(position: Euclid.Vector, plane: Euclid.Plane) -> Builder {
        
        let legUVs = UVs(start: Vector(x: 0, y: 0.5, z: 0), end: Vector(x: 1, y: 0.75, z: 0))
        let trunkUVs = UVs(start: Vector(x: 0, y: 0.75, z: 0), end: Vector(x: 1, y: 1, z: 0))
        
        let size = Vector(Double(trunk.segments), 0, Double(stump.segments))
        let sampleCount = Vector(Double(trunk.segments), 0, Double(stump.segments))
        
        let map = noise.map(size: size, sampleCount: sampleCount)
        
        let sample = Double(map.value(at: vector2(1, 0)))
        
        let curveStep = 1.0 / Double(trunk.slices)
        let yStep = trunk.height / Double(trunk.slices)
        let offset = Vector(sample * trunk.spread, trunk.height, sample * trunk.spread)
        let control = Vector(0, trunk.height, 0)
        let normal = curve(start: position, end: offset, control: control, interpolator: curveStep)
            
        var mesh = Euclid.Mesh([])
        
        //
        /// Create stump legs
        //
        
        guard let plane = Plane(normal: normal, pointOnPlane: .zero) else { return ([], position, plane) }
        
        var rotation = Euclid.Angle(radians: Math.pi2 / Double(stump.legs))
        
        for leg in 0..<stump.legs {
            
            let angle = (rotation.radians * Double(leg))
            
            let trunkLeg = TrunkLeg(plane: plane, noise: noise, angle: angle, spread: stump.spread, innerRadius: stump.innerRadius, outerRadius: stump.outerRadius, peak: stump.peak, base: stump.base, segments: stump.segments, textureCoordinates: legUVs)
            
            mesh = mesh.union(Mesh(trunkLeg.build(position: position)))
        }
        
        //
        /// Create trunk segments
        //
        
        var slices: [[Euclid.Vector]] = []
        
        rotation = Euclid.Angle(radians: Math.pi2 / Double(trunk.segments))
        
        for slice in 0...trunk.slices {
            
            let interpolator = curveStep * Double(slice)
            
            var layer: [Euclid.Vector] = []
            
            let length = (1.0 - Math.ease(curve: .out, value: interpolator)) * (trunk.baseRadius - trunk.peakRadius)
            
            let radius = slice == 0 ? trunk.baseRadius : (trunk.peakRadius + length)
            
            for segment in 0..<trunk.segments {
                
                let angle = (rotation * Double(segment)) + (rotation / 2.0)
                
                let distance = Double(slice) * yStep
                
                var point = plot(radians: angle.radians, radius: radius).project(onto: plane) + (plane.normal * (distance))
                
                if slice == 0 {
                    
                    point.y += TrunkLeg.Constants.floor
                }
                
                layer.append(point)
            }
            
            slices.append(layer)
            
            if slices.count > 1 {
                
                let lower = slices.removeFirst()
                
                guard let upper = slices.first else { continue }
                
                let trunkSlice = TrunkSlice(upper: upper, lower: lower, cap: (slice == 1 ? .throne : slice == trunk.slices ? .apex : nil), textureCoordinates: trunkUVs)
                
                mesh = mesh.union(Mesh(trunkSlice.build(position: position)))
            }
        }
        
        return (mesh.polygons, slices.last?.average() ?? position, plane)
    }
}
