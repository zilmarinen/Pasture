//
//  StoneStairs.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Euclid
import Foundation
import Meadow

struct StoneStairs: Prop {
    
    let style: StairType
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let elevation = style.steep ? 2 : 1
        
        let size = Coordinate(x: style.footprint.bounds.size.x, y: elevation, z: style.footprint.bounds.size.z)
        
        let steps = 2 * elevation
        let scalar = 1.0 / Double(steps)
        let offset = position - Vector(x: World.Constants.volumeSize, y: 0, z: World.Constants.volumeSize)
        
        let lowerFace = [offset,
                         offset + Vector(x: Double(size.x), y: 0, z: 0),
                         offset + Vector(x: Double(size.x), y: 0, z: Double(size.z)),
                         offset + Vector(x: 0, y: 0, z: Double(size.z))]
        
        let upperFace = lowerFace.map { $0 + Vector(x: 0, y: World.Constants.slope * Double(elevation), z: 0) }
        
        var polygons: [Euclid.Polygon] = []
        
        for step in 0..<steps {
            
            var apex: [Vector] = []
            var throne: [Vector] = []
            
            let i = Double(step)
            let j = Double(step + 1)
            
            for cardinal in Cardinal.allCases {
                
                apex.append(lowerFace[cardinal.rawValue].lerp(upperFace[cardinal.rawValue], j * scalar))
                throne.append(lowerFace[cardinal.rawValue].lerp(upperFace[cardinal.rawValue], i * scalar))
            }
            
            let uv0 = apex[Ordinal.northWest.rawValue]
            let uv1 = apex[Ordinal.northEast.rawValue]
            let uv2 = apex[Ordinal.southEast.rawValue]
            let uv3 = apex[Ordinal.southWest.rawValue]
            
            let lv0 = throne[Ordinal.northWest.rawValue]
            let lv1 = throne[Ordinal.northEast.rawValue]
            let lv2 = throne[Ordinal.southEast.rawValue]
            let lv3 = throne[Ordinal.southWest.rawValue]
            
            let uc0 = uv3.lerp(uv0, j * scalar)
            let uc1 = uv2.lerp(uv1, j * scalar)
            let uc2 = uv2.lerp(uv1, i * scalar)
            let uc3 = uv3.lerp(uv0, i * scalar)
            
            let lc0 = lv3.lerp(lv0, i * scalar)
            let lc1 = lv2.lerp(lv1, i * scalar)
            
            let faces = [[uc0, uc1, uc2, uc3],
                         [uc3, uc2, lc1, lc0]]
            
            for face in faces {
                
                let normal = -face.normal()
                
                var vertices: [Vertex] = []
                
                for index in face.indices.reversed() {
                    
                    vertices.append(Vertex(face[index], normal))
                }
                
                guard let polygon = Polygon(vertices) else { continue }
                
                polygons.append(polygon)
            }
        }
        
        return polygons
    }
}
