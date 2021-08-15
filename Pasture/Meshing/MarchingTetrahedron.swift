//
//  MarchingTetrahedron.swift
//
//  Created by Zack Brown on 23/06/2021.
//

import Euclid
import Foundation
import Meadow

enum MarchingTetrahedron {
    
    static func march(chunk: SDFGrid.Chunk, size: Vector) -> [Euclid.Polygon] {
        
        var polygons: [Euclid.Polygon] = []
        
        for tetrahedron in MarchingTetrahedron.tetrahedrons {
            
            var identifier = 0
        
            for index in tetrahedron.indices {
                
                let corner = tetrahedron[index]
            
                let value = chunk.values[corner]
            
                if value >= 0.0 {
                
                    identifier |= 1 << index
                }
            }
            
            guard identifier > 0 && identifier < 15 else { continue }
            
            for triangle in triangles[identifier - 1] {
                
                var face: [Vector] = []
                
                for edge in triangle {
                    
                    guard let c0 = edges[edge].first,
                          let c1 = edges[edge].last else { continue }
                    
                    let c2 = tetrahedron[c0]
                    let c3 = tetrahedron[c1]
                    
                    let v0 = SDFGrid.corners[c2] * size
                    let v1 = SDFGrid.corners[c3] * size
                    
                    let slope = chunk.slope(c0: c2, c1: c3)
                    
                    face.append(chunk.position + (v0 + ((v1 - v0) * slope)))
                }
                
                let normal = face.normal()
                
                let vertices = face.map { Vertex($0, normal) }
                
                guard let polygon = Polygon(vertices) else { continue }
                
                polygons.append(polygon)
            }
        }
        
        return polygons
    }
}

extension MarchingTetrahedron {
    
    static let tetrahedrons = [
        
        [0, 5, 1, 6],
        [0, 1, 2, 6],
        [0, 2, 3, 6],
        [0, 3, 7, 6],
        [0, 7, 4, 6],
        [0, 4, 5, 6]
    ]
    
    static let edges = [
        
        [0, 1],
        [1, 2],
        [2, 0],
        [0, 3],
        [1, 3],
        [2, 3]
    ]
    
    static let triangles = [
        
        [[0, 3, 2]],
        [[0, 1, 4]],
        [[1, 4, 2], [2, 4, 3]],
        [[1, 2, 5]],
        [[0, 3, 5], [0, 5, 1]],
        [[0, 2, 5], [0, 5, 4]],
        [[5, 4, 3]],
        [[3, 4, 5]],
        [[4, 5, 0], [5, 2, 0]],
        [[1, 5, 0], [5, 3, 0]],
        [[5, 2, 1]],
        [[3, 4, 2], [2, 4, 1]],
        [[4, 1, 0]],
        [[2, 3, 0]]
    ]
}
