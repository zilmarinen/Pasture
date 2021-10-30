//
//  SaltboxRoof.swift
//
//  Created by Zack Brown on 23/07/2021.
//

import Euclid
import Foundation
import Meadow

struct SaltboxRoof: Prop {
    
    enum Peak: CaseIterable, Codable, Hashable, Identifiable {
        
        case left
        case center
        case right
        
        var id: String {
            
            switch self {
                
            case .left: return "Left"
            case .center: return "Center"
            case .right: return "Right"
            }
        }
        
        var length: Double {
            
            switch self {
                
            case .left: return 0.33
            case .center: return 0.5
            case .right: return 0.66
            }
        }
    }
    
    let footprint: Footprint
    
    let configuration: [Coordinate : GridPattern<Building.Element>]
    
    let architecture: Building.Architecture
    
    let height: Double
    let slope: Double
    let inset: Double
    
    let direction: Cardinal
    let peak: Peak
    
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
            
            fasciaCorners[o0.corner] = fasciaCorners[o0.corner] + (-normal * (inset / 2.0))
            fasciaCorners[o1.corner] = fasciaCorners[o1.corner] + (-normal * (inset / 2.0))
            
            wallCorners[o0.corner] = wallCorners[o0.corner] + (-normal * inset)
            wallCorners[o1.corner] = wallCorners[o1.corner] + (-normal * inset)
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
        
        let v4 = v0.lerp(v1, peak.length) + Vector(0, slope, 0)
        let v5 = v3.lerp(v2, peak.length) + Vector(0, slope, 0)
        
        let uv4 = uv0.lerp(uv1, peak.length)
        let uv5 = uv3.lerp(uv2, peak.length)
        
        guard let olhs = polygon(vectors: [v1, v4, v0], uvs: [uv1, uv4, uv0]),
              let orhs = polygon(vectors: [v3, v5, v2], uvs: [uv3, uv5, uv2]),
              let ulhs = polygon(vectors: [v0, v4, v5, v3], uvs: uvs),
              let urhs = polygon(vectors: [v4, v1, v2, v5], uvs: uvs),
              let throne = polygon(vectors: vertices, uvs: uvs) else { return Mesh([]) }
        
        return Mesh([olhs, orhs, ulhs, urhs, throne])
    }
    
    func roof(vertices: [Vector], uvs: [Vector]) -> Euclid.Mesh {
        
        let (v0, v1, v2, v3) = (vertices[3], vertices[2], vertices[1], vertices[0])
    
        let v4 = v0.lerp(v1, peak.length) + Vector(0, slope, 0)
        let v5 = v3.lerp(v2, peak.length) + Vector(0, slope, 0)
        
        let mesh = Mesh(face(vertices: [v0, v4, v5, v3], uvs: uvs))
        
        return mesh.union(Mesh(face(vertices: [v4, v1, v2, v5], uvs: uvs)))
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
            
            let v0 = vertices[o1.corner]
            let v1 = vertices[o0.corner]
            let v2 = lowerVertices[o0.corner]
            let v3 = lowerVertices[o1.corner]
            
            guard let face = polygon(vectors: [v0, v1, v2, v3], uvs: uvs) else { continue }
            
            polygons.append(face)
        }
        
        return polygons
    }
}
