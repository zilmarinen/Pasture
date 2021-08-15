//
//  SDFGrid.swift
//
//  Created by Zack Brown on 25/06/2021.
//

import Euclid
import Foundation
import Meadow
import SwiftUI

public class SDFGrid {
    
    public enum Method {
        
        case cubes
        case tetrahedron
    }
    
    struct Chunk {
        
        let position: Vector
        let values: [Double]
        
        func slope(c0: Int, c1: Int) -> Double {
            
            let s0 = values[c0]
            let s1 = values[c1]
            
            let delta = s1 - s0
            
            return -s0 / delta
        }
    }
    
    let footprint: Footprint
    let resolution: Int
    
    var graph = SDFGroup()
    
    public init(footprint: Footprint, resolution: Int) {
        
        self.footprint = footprint
        self.resolution = max(resolution, 1)
    }
    
    public func march(method: Method) -> [Euclid.Polygon] {
        
        let step = 1.0 / Double(resolution + 1)
        let size = Vector(step, step, step)
        
        var polygons: [Euclid.Polygon] = []
        
        for node in footprint.nodes {
            
            for x in stride(from: -0.5, to: 0.5, by: size.x) {
                
                for y in stride(from: -0.5, to: 0.5, by: size.y) {
                 
                    for z in stride(from: -0.5, to: 0.5, by: size.z) {
                        
                        let position = Vector(Double(node.x) + x, Double(node.y) + y, Double(node.z) + z)
                        
                        var values: [Double] = Array(repeating: 0, count: 8)
                        
                        for index in values.indices {
                            
                            values[index] = graph.sample(region: position + (SDFGrid.corners[index] * size))
                        }
                        
                        let chunk = Chunk(position: position, values: values)
                        
                        switch method {
                            
                        case .cubes:
                            
                            polygons.append(contentsOf: MarchingCube.march(chunk: chunk, size: size))
                            
                        case .tetrahedron:
                            
                            polygons.append(contentsOf: MarchingTetrahedron.march(chunk: chunk, size: size))
                        }
                    }
                }
            }
        }
        
        return polygons
    }
}

extension SDFGrid {
    
    public func add(shape: SDFShape) {
        
        graph.add(shape: shape)
    }
    
    public func remove(shape: SDFShape) {
        
        graph.remove(shape: shape)
    }
}

extension SDFGrid {
    
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
}
