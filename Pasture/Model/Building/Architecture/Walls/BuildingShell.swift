//
//  BuildingShell.swift
//
//  Created by Zack Brown on 19/07/2021.
//

import Euclid
import Foundation
import Meadow

struct BuildingShell: Prop {
    
    let configuration: [Coordinate : GridPattern<Building.Element>]
    
    let layers: Int
    
    let height: Double
    
    let cornerInset: Double
    let edgeInset: Double
    
    let angled: Bool
    
    let textureCoordinates: UVs
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        let size = Vector(World.Constants.volumeSize, 0.0, World.Constants.volumeSize)
        
        let roofUVs = Ordinal.uvs.map { Euclid.Vector($0.x, $0.y) }.inset(axis: .y, corner: cornerInset, edge: edgeInset)
        let wallUVs = Ordinal.uvs.map { Euclid.Vector($0.x, $0.y) }.inset(axis: .y, corner: cornerInset, edge: edgeInset)
        
        let vertices = Ordinal.Coordinates.map { (size * Vector(Double($0.x), 0, Double($0.z))) }.inset(axis: .z, corner: cornerInset, edge: edgeInset)
        
        var polygons: [Euclid.Polygon] = []
        
        for (node, pattern) in configuration {
            
            let offset = position + Vector(Double(node.x), 0, Double(node.z))
            
            for cardinal in Cardinal.allCases {
                
                let (o0, o1) = cardinal.ordinals
                let (c0, c1) = cardinal.cardinals
                
                guard pattern.value(for: cardinal) != .empty,
                      let (_, e0) = vertices.edges.outer[c0],
                      let (e1, _) = vertices.edges.outer[c1],
                      let (woeuv0, _) = wallUVs.edges.outer[.north],
                      let (woeuv1, _) = wallUVs.edges.outer[.south] else { continue }
                
                let normal = Euclid.Vector(cardinal.normal.x, cardinal.normal.y, cardinal.normal.z)
                
                var v0 = pattern.value(for: c0) == .empty ? e0 : vertices.corners.inner[o0.rawValue]
                var v1 = pattern.value(for: c1) == .empty ? e1 : vertices.corners.inner[o1.rawValue]
                
                var startUV = wallUVs.corners.outer[0]
                var endUV = wallUVs.corners.outer[2]
                
                if angled {
                    
                    guard let (v2, v3) = vertices.edges.inner[cardinal] else { continue }
                    
                    if pattern.value(for: o0) == .corner {
                    
                        v0 = v2
                        endUV = woeuv1
                    }
                    
                    if pattern.value(for: o1) == .corner {
                        
                        v1 = v3
                        startUV = woeuv0
                    }
                }
                
                for layer in 0..<layers {
                
                    let uvs = UVs(start: Vector(x: startUV.x, y: startUV.y, z: startUV.z), end: Vector(x: endUV.x, y: endUV.y, z: endUV.z))
                
                    let wall = BuildingWall(c0: v0, c1: v1, height: height, layer: layer, normal: normal, textureCoordinates: uvs)
                
                    polygons.append(contentsOf: wall.build(position: offset))
                }
            }
            
            var floorVertices: [Euclid.Vector] = []
            var floorUVs: [Euclid.Vector] = []
            
            for ordinal in Ordinal.allCases {
                
                let (c0, c1) = ordinal.cardinals
                let innerCorner = pattern.value(for: c0) == .empty && pattern.value(for: c1) == .empty
                
                guard let (_, oe0) = vertices.edges.outer[c0],
                      let (oe1, _) = vertices.edges.outer[c1],
                      let (_, ie0) = vertices.edges.inner[c0],
                      let (ie1, _) = vertices.edges.inner[c1],
                      let (_, woeuv0) = wallUVs.edges.outer[.north],
                      let (_, woeuv1) = wallUVs.edges.outer[.south],
                      let (_, roeuv0) = roofUVs.edges.outer[c0],
                      let (roeuv1, _) = roofUVs.edges.outer[c1],
                      let (_, rieuv0) = roofUVs.edges.inner[c0],
                      let (rieuv1, _) = roofUVs.edges.inner[c1] else { continue }
                
                let n0 = Euclid.Vector(c0.normal.x, c0.normal.y, c0.normal.z)
                let n1 = Euclid.Vector(c1.normal.x, c1.normal.y, c1.normal.z)
                
                if angled {
                    
                    let v0 = innerCorner ? oe0 : ie0
                    let v1 = innerCorner ? oe1 : ie1
                    let v2 = v0.lerp(v1, 0.5)
                    let an = (n0 + n1) / 2.0
                    
                    switch pattern.value(for: ordinal) {
                
                    case .corner:
                        
                        floorVertices.append(contentsOf: [v0, v1])
                        floorUVs.append(contentsOf: innerCorner ? [roeuv0, roeuv1] : [rieuv0, rieuv1])
                        
                        let uv0 = UVs(start: Vector(x: wallUVs.corners.outer[0].x, y: wallUVs.corners.outer[0].y, z: wallUVs.corners.outer[0].z), end: Vector(x: woeuv1.x, y: woeuv1.y, z: woeuv1.z))
                        let uv1 = UVs(start: Vector(x: woeuv0.x, y: woeuv0.y, z: woeuv0.z), end: Vector(x: wallUVs.corners.outer[2].x, y: wallUVs.corners.outer[2].y, z: wallUVs.corners.outer[2].z))
                        
                        for layer in 0..<layers {
                            
                            let lhs = BuildingWall(c0: v0, c1: v2, height: height, layer: layer, normal: an, textureCoordinates: innerCorner ? uv1 : uv0)
                            let rhs = BuildingWall(c0: v2, c1: v1, height: height, layer: layer, normal: an, textureCoordinates: innerCorner ? uv0 : uv1)
                        
                            polygons.append(contentsOf: lhs.build(position: offset))
                            polygons.append(contentsOf: rhs.build(position: offset))
                        }
                        
                    case .wall:
                        
                        let hardEdge = configuration[node + c0.coordinate] != nil
                        
                        floorVertices.append(hardEdge ? oe0 : oe1)
                        floorUVs.append(hardEdge ? roeuv0 : roeuv1)
                        
                    default:
                        
                        floorVertices.append(vertices.corners.outer[ordinal.rawValue])
                        floorUVs.append(roofUVs.corners.outer[ordinal.rawValue])
                    }
                }
                else {
                    
                    let v0 = vertices.corners.inner[ordinal.rawValue]
                    
                    switch pattern.value(for: ordinal) {
                        
                    case .corner:
                        
                        if innerCorner {
                            
                            floorVertices.append(contentsOf: [oe0, v0, oe1])
                            floorUVs.append(contentsOf: [roeuv0, roofUVs.corners.inner[ordinal.rawValue], roeuv1])
                        }
                        else {
                        
                            floorVertices.append(v0)
                            floorUVs.append(roofUVs.corners.inner[ordinal.rawValue])
                        }
                    
                    case .wall:
                        
                        let hardEdge = configuration[node + c0.coordinate] != nil
                        
                        floorVertices.append(hardEdge ? oe0 : oe1)
                        floorUVs.append(hardEdge ? roeuv0 : roeuv1)
                        
                    default:
                        
                        floorVertices.append(vertices.corners.outer[ordinal.rawValue])
                        floorUVs.append(roofUVs.corners.outer[ordinal.rawValue])
                    }
                    
                    guard innerCorner, pattern.value(for: ordinal) == .corner else { continue }
                    
                    let uv0 = UVs(start: Vector(x: woeuv0.x, y: woeuv0.y, z: woeuv0.z), end: Vector(x: wallUVs.corners.outer[2].x, y: wallUVs.corners.outer[2].y, z: wallUVs.corners.outer[2].z))
                    let uv1 = UVs(start: Vector(x: wallUVs.corners.outer[0].x, y: wallUVs.corners.outer[0].y, z: wallUVs.corners.outer[0].z), end: Vector(x: woeuv1.x, y: woeuv1.y, z: woeuv1.z))
                    
                    for layer in 0..<layers {
                    
                        let lhs = BuildingWall(c0: oe0, c1: v0, height: height, layer: layer, normal: n0, textureCoordinates: uv0)
                        let rhs = BuildingWall(c0: v0, c1: oe1, height: height, layer: layer, normal: n1, textureCoordinates: uv1)
                    
                        polygons.append(contentsOf: lhs.build(position: offset) + rhs.build(position: offset))
                    }
                }
            }
            
            guard let throne = polygon(vectors: floorVertices.map { $0 + offset }, uvs: floorUVs),
                  let apex = polygon(vectors: floorVertices.reversed().map { $0 + offset + Vector(0, Double(layers) * height, 0) }, uvs: floorUVs.reversed()) else { continue }
            
            polygons.append(contentsOf: [throne, apex])
        }
        
        return polygons
    }
}
