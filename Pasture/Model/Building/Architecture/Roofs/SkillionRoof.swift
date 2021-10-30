//
//  SkillionRoof.swift
//
//  Created by Zack Brown on 28/07/2021.
//

import Euclid
import Foundation
import Meadow

struct SkillionRoof: Prop {
    
    let footprint: Footprint
    
    let configuration: [Coordinate : GridPattern<Building.Element>]
    
    let architecture: Building.Architecture
    
    let height: Double
    let slope: Double
    let inset: Double
    
    let direction: Cardinal
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        var outerCorners = [position + Vector(Double(footprint.bounds.start.x) - 0.5, 0, Double(footprint.bounds.start.z) - 0.5),
                            position + Vector(Double(footprint.bounds.end.x) + 0.5, 0, Double(footprint.bounds.start.z) - 0.5),
                            position + Vector(Double(footprint.bounds.end.x) + 0.5, 0, Double(footprint.bounds.end.z) + 0.5),
                            position + Vector(Double(footprint.bounds.start.x) - 0.5, 0, Double(footprint.bounds.end.z) + 0.5)]
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        let cornerTextureCoordinates = UVs(start: Vector(0.5, 0.375), end: Vector(1.0, 0.5))
        let roofTextureCoordinates = UVs(start: .zero, end: Vector(0.5, 0.5))
        let shingleTextureCoordinates = UVs(start: Vector(0.5, 0.0), end: Vector(1.0, 0.125))
        let fasciaTextureCoordinates = UVs(start: Vector(0.5, 0.125), end: Vector(1.0, 0.25))
        
        if direction == .east || direction == .west {
            
            outerCorners = [outerCorners[1], outerCorners[2], outerCorners[3], outerCorners[0]]
        }
        
        var fasciaCorners = outerCorners
        var wallCorners = outerCorners
        
        for cardinal in Cardinal.allCases {
         
            let (o0, o1) = cardinal.ordinals
            let normal = Vector(cardinal.normal.x, cardinal.normal.y, cardinal.normal.z)
            
            fasciaCorners[o0.rawValue] = fasciaCorners[o0.rawValue] + (-normal * (inset / 2.0))
            fasciaCorners[o1.rawValue] = fasciaCorners[o1.rawValue] + (-normal * (inset / 2.0))
            
            wallCorners[o0.rawValue] = wallCorners[o0.rawValue] + (-normal * inset)
            wallCorners[o1.rawValue] = wallCorners[o1.rawValue] + (-normal * inset)
        }
        
        let shingleShell = BuildingShell(configuration: configuration, architecture: architecture, layers: 1, height: (World.Constants.slope * 4), inset: 0, angled: architecture.angled, cornerStyle: .plain, cutaways: false, uvs: (shingleTextureCoordinates, shingleTextureCoordinates, roofTextureCoordinates))
        let fasciaShell = BuildingShell(configuration: configuration, architecture: architecture, layers: 1, height: (World.Constants.slope * 4), inset: (inset / 2.0), angled: architecture.angled, cornerStyle: .plain, cutaways: false, uvs: (fasciaTextureCoordinates, fasciaTextureCoordinates, roofTextureCoordinates))
        let wallShell = BuildingShell(configuration: configuration, architecture: architecture, layers: 1, height: (World.Constants.slope * 4), inset: inset, angled: architecture.angled, cornerStyle: architecture.masonryStyle, cutaways: false, uvs: (wallTextureCoordinates, cornerTextureCoordinates, roofTextureCoordinates))
        
        var shingles = roof(vertices: outerCorners, uvs: roofTextureCoordinates.corners)
        
        shingles = shingles.intersect(Mesh(shingleShell.build(position: position - Vector(0, height, 0))))
        
        var fascia = roof(vertices: fasciaCorners.map { $0 - Vector(0, height / 2, 0) }, uvs: fasciaTextureCoordinates.corners)
        fascia = fascia.intersect(Mesh(fasciaShell.build(position: position - Vector(0, height * 2, 0))))
        
        var walls = walls(vertices: wallCorners.map { $0 - Vector(0, height, 0) }, uvs: wallTextureCoordinates.corners)
        walls = walls.intersect(Mesh(wallShell.build(position: position - Vector(0, height, 0))))
        
        return walls.union(shingles.union(fascia)).polygons
    }
    
    func walls(vertices: [Vector], uvs: [Vector]) -> Euclid.Mesh {
        
        let (v0, v1, v2, v3) = (vertices[3], vertices[2], vertices[1], vertices[0])
        let (uv0, uv1, uv2, uv3) = (uvs[3], uvs[2], uvs[1], uvs[0])
        
        let v4 = (direction == .north || direction == .east ? v0 : v1) + Vector(0, slope, 0)
        let v5 = (direction == .north || direction == .east ? v3 : v2) + Vector(0, slope, 0)
        
        let uv4 = uv0.lerp(uv1, slope)
        let uv5 = uv3.lerp(uv2, slope)
        
        guard let olhs = polygon(vectors: [v1, v4, v0], uvs: [uv1, uv4, uv0]),
              let orhs = polygon(vectors: [v3, v5, v2], uvs: [uv3, uv5, uv2]),
              let front = polygon(vectors: [v0, v4, v5, v3], uvs: uvs),
              let apex = polygon(vectors: [v4, v1, v2, v5], uvs: uvs),
              let throne = polygon(vectors: vertices, uvs: uvs) else { return Mesh([]) }
        
        return Mesh([olhs, orhs, front, apex, throne])
    }
    
    func roof(vertices: [Vector], uvs: [Vector]) -> Euclid.Mesh {
        
        var (v0, v1, v2, v3) = (vertices[3], vertices[2], vertices[1], vertices[0])
    
        switch direction {
            
        case .north,
                .east:
            
            v0.y += slope
            v3.y += slope
            
        default:
            
            v1.y += slope
            v2.y += slope
        }
        
        return Mesh(face(vertices: [v0, v1, v2, v3], uvs: uvs))
    }
    
    func face(vertices: [Vector], uvs: [Vector]) -> [Euclid.Polygon] {
        
        guard vertices.count == uvs.count else { return [] }
        
        let normal = vertices.normal()
        
        let lowerVertices = vertices.map { $0 + (-normal * height) }
        
        var polygons: [Euclid.Polygon] = []
        
        guard let upperFace = polygon(vectors: vertices, uvs: uvs),
              let lowerFace = polygon(vectors: lowerVertices.reversed(), uvs: uvs) else { return [] }
        
        polygons.append(contentsOf: [upperFace, lowerFace])
        
        for cardinal in Cardinal.allCases {
            
            let (o0, o1) = cardinal.ordinals
            
            let v0 = vertices[o1.rawValue]
            let v1 = vertices[o0.rawValue]
            let v2 = lowerVertices[o0.rawValue]
            let v3 = lowerVertices[o1.rawValue]
            
            guard let face = polygon(vectors: [v0, v1, v2, v3], uvs: uvs) else { continue }
            
            polygons.append(face)
        }
        
        return polygons
    }
}
