//
//  Causeway.swift
//
//  Created by Zack Brown on 28/06/2021.
//

import Euclid
import Foundation
import GameKit
import Meadow
import SwiftUI

class Causeway: Codable, Hashable, ObservableObject {
    
    static let `default`: Causeway = Causeway(radius: 0.1,
                                              margin: 0.01,
                                              peak: 0.49,
                                              base: 0.28,
                                              noise: .default,
                                              shape: .hexagon,
                                              pentomino: .z)
 
    enum CodingKeys: CodingKey {
        
        case radius
        case margin
        case peak
        case base
        case noise
        case shape
        case pentomino
    }
    
    enum Shape: String, CaseIterable, Codable, Hashable, Identifiable {
        
        case hexagon
        case square
        
        var id: String { self.rawValue }
    }
    
    @Published var radius: Double
    @Published var margin: Double
    @Published var peak: Double
    @Published var base: Double
    @Published var noise: Noise
    @Published var shape: Shape
    @Published var pentomino: Pentomino
    
    init(radius: Double,
         margin: Double,
         peak: Double,
         base: Double,
         noise: Noise,
         shape: Shape,
         pentomino: Pentomino) {
        
        self.radius = radius
        self.margin = margin
        self.peak = peak
        self.base = base
        self.noise = noise
        self.shape = shape
        self.pentomino = pentomino
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        radius = try container.decode(Double.self, forKey: .radius)
        margin = try container.decode(Double.self, forKey: .margin)
        peak = try container.decode(Double.self, forKey: .peak)
        base = try container.decode(Double.self, forKey: .base)
        noise = try container.decode(Noise.self, forKey: .noise)
        shape = try container.decode(Shape.self, forKey: .shape)
        pentomino = try container.decode(Pentomino.self, forKey: .pentomino)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(radius, forKey: .radius)
        try container.encode(margin, forKey: .margin)
        try container.encode(peak, forKey: .peak)
        try container.encode(base, forKey: .base)
        try container.encode(noise, forKey: .noise)
        try container.encode(shape, forKey: .shape)
        try container.encode(pentomino, forKey: .pentomino)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(radius)
        hasher.combine(margin)
        hasher.combine(peak)
        hasher.combine(base)
        hasher.combine(noise)
        hasher.combine(shape)
        hasher.combine(pentomino)
    }
    
    static func == (lhs: Causeway, rhs: Causeway) -> Bool {
        
        return  lhs.radius == rhs.radius &&
                lhs.margin == rhs.margin &&
                lhs.peak == rhs.peak &&
                lhs.base == rhs.base &&
                lhs.noise == rhs.noise &&
                lhs.shape == rhs.shape &&
                lhs.pentomino == rhs.pentomino
    }
}

extension Causeway: Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        let uvStep = 1.0 / Double(4)
        let xStep = sqrt(3) * (radius + margin)
        let zStep = ((radius * 1.5) + margin)
        let columns = Int(1.0 / xStep)
        let rows = Int(1.0 / zStep)
        let spread = 0.07
        let offset = Vector(-0.5 + (radius + margin), 0, -0.5 + (radius + margin))
        
        let size = Vector(Double(pentomino.footprint.bounds.size.x), 0, Double(pentomino.footprint.bounds.size.z))
        let sampleCount = Vector(size.x * Double(rows), 0, size.z * Double(columns))
        
        let map = noise.map(size: size, sampleCount: sampleCount, origin: Vector(-size.x, 0, -size.z))

        var polygons: [Euclid.Polygon] = []
        
        for node in pentomino.footprint.nodes {
            
            let corner = Vector(Double(node.x) + offset.x, 0, Double(node.z) + offset.z)
            
            for row in 0..<rows {
                
                for column in 0..<columns {
                    
                    let x = (Double(column) * xStep) + (row % 2 == 0 ? 0 : xStep / 2.0)
                    let z = Double(row) * zStep
                    
                    let center = corner + Vector(x, 0, z)
                    
                    let s0 = Double(map.value(at: vector2(Int32((corner.x + x) / xStep), Int32((corner.z + z) / zStep))))
                    let s1 = Double(map.value(at: vector2(Int32((corner.z + z) / zStep), Int32((corner.x + x) / xStep))))
                    
                    guard s0 >= 0 else { continue }
                    
                    let uvc = Double((column * row) % 4)
                    
                    let uvx0 = (uvStep * uvc)
                    let uvx1 = (uvStep * (uvc + 1))
                    
                    let uvs = UVs(start: Vector(x: uvx0, y: 0.0, z: 0.0), end: Vector(x: uvx1, y: 1.0, z: 0.0))
                    
                    polygons.append(contentsOf: self.column(position: center, elevation: s0, textureCoordinates: uvs, spread: s1 * spread))
                }
            }
        }
        
        return polygons
    }
}

extension Causeway {
    
    func column(position: Euclid.Vector, elevation: Double, textureCoordinates: UVs, spread: Double) -> [Euclid.Polygon] {
        
        let segments = (shape == .hexagon ? 6 : 4)
        let rotation = Euclid.Angle(radians: Math.pi2 / Double(segments))
        
        let uvStep = (textureCoordinates.end.x - textureCoordinates.start.x) / Double(segments)
        
        var center = position + Vector(0, base + ((peak - base) * elevation), 0)
        let offset = Vector(spread, center.y, spread).normalized()
        
        guard let plane = Plane(normal: offset, pointOnPlane: center) else { return [] }
        
        var polygons: [Euclid.Polygon] = []
        
        center.y = center.project(onto: plane).y
        
        for segment in 0..<segments {
            
            let uvx0 = textureCoordinates.start.x + (uvStep * Double(segment))
            let uvx1 = textureCoordinates.start.x + (uvStep * Double(segment + 1))
            
            let uv0 = Euclid.Vector(uvx1, textureCoordinates.start.y)
            let uv1 = Euclid.Vector(uvx0, textureCoordinates.start.y)
            let uv2 = Euclid.Vector(uvx0, textureCoordinates.end.y)
            let uv3 = Euclid.Vector(uvx1, textureCoordinates.end.y)
            
            let peakUV = uv0.lerp(uv1, 0.5)
            
            let a0 = rotation * Double(segment)
            let a1 = rotation * Double((segment + 1) % segments)
            
            let v0 = position + plot(radians: a0.radians, radius: radius)
            let v1 = position + plot(radians: a1.radians, radius: radius)
            
            let v2 = Vector(v1.x, v1.project(onto: plane).y, v1.z)
            let v3 = Vector(v0.x, v0.project(onto: plane).y, v0.z)
            
            guard let polygon = self.polygon(vectors: [v0, v1, v2, v3], uvs: [uv0, uv1, uv2, uv3]) else { continue }
            
            polygons.append(polygon)
            
            guard let polygon = self.polygon(vectors: [v3, v2, center], uvs: [uv3, uv2, peakUV]) else { continue }
            
            polygons.append(polygon)
        }
        
        return polygons
    }
}
