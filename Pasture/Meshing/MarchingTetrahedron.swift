//
//  MarchingTetrahedron.swift
//
//  Created by Zack Brown on 23/06/2021.
//

import Euclid
import Foundation

public enum MarchingTetrahedron {
    
    public static func march(identifier: Int, position: Vector, size: Vector) -> [Polygon] {
        
        guard identifier > 0 && identifier < 15 else { return [] }
        
        var polygons: [Polygon] = []
        
        for triangle in triangles[identifier - 1] {
            
            var face: [Vector] = []
            
            for edge in triangle.reversed() {
                
                guard let c0 = edges[edge].first,
                      let c1 = edges[edge].last else {
                          
                          print("INDEX OUT OF BPUNDS")
                          continue }
                
                let v0 = corners[c0] * size
                let v1 = corners[c1] * size
                
                face.append(position + ((v0 + v1) / 2.0))
            }
            
            let normal = face.normal()
            
            let vertices = face.map { Vertex($0, normal) }
            
            guard let polygon = Polygon(vertices) else {
                print("Shitty vertices: [\(vertices.count)]")
                continue }
            
            polygons.append(polygon)
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
    
    static let corners = [
        
        Vector(0, 0, 0),
        Vector(1, 0, 0),
        Vector(1, 1, 0),
        Vector(0, 1, 0),
        Vector(0, 0, 1),
        Vector(1, 0, 1),
        Vector(1, 1, 1),
        Vector(0, 1, 1)
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
