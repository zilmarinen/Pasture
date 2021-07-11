//
//  SDFGrid.swift
//
//  Created by Zack Brown on 25/06/2021.
//

import Euclid
import Foundation
import Meadow

public class SDFGrid {
    
    public enum Method {
        
        case cubes
        case tetrahedron
    }
    
    let footprint: Footprint
    let resolution: Int
    
    var shapes: [SDFShape] = []
    
    public init(footprint: Footprint, resolution: Int) {
        
        self.footprint = footprint
        self.resolution = max(resolution, 1)
    }
    
    public func march(method: Method) -> [Euclid.Polygon] {
        
        let step = 1.0 / Double(resolution)
        let size = Vector(step, step, step)
        
        var polygons: [Euclid.Polygon] = []

        for node in footprint.nodes {
            
            for x in stride(from: -0.5, to: 0.5, by: step) {
                
                for y in stride(from: -0.1, to: 3, by: step) {
                 
                    for z in stride(from: -0.5, to: 0.5, by: step) {
                        
                        let position = Vector(Double(node.x) + x, Double(node.y) + y, Double(node.z) + z)
                        
                        var identifier = 0
                        
                        switch method {
                            
                        case .cubes:
                            
                            for index in MarchingCube.corners.indices {
                                
                                let value = sample(region: position + (MarchingCube.corners[index] * step))
                                
                                if abs(value) >= Math.epsilon {
                                    
                                    identifier |= 1 << index
                                }
                            }
                            
                            polygons.append(contentsOf: MarchingCube.march(identifier: identifier, position: position, size: size))
                            
                        case .tetrahedron:
                            
                            for tetrahedron in MarchingTetrahedron.tetrahedrons {
                                
                                var identifier = 0
                            
                                for index in tetrahedron.indices {
                                    
                                    let corner = tetrahedron[index]
                                
                                    let value = sample(region: position + (MarchingTetrahedron.corners[corner] * step))
                                
                                    if abs(value) >= Math.epsilon {
                                    
                                        identifier |= 1 << index
                                    }
                                }
                                
                                polygons.append(contentsOf: MarchingTetrahedron.march(identifier: identifier, position: position, size: size))
                            }
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
        
        guard !shapes.contains(shape) else { return }
        
        shapes.append(shape)
    }
    
    public func remove(shape: SDFShape) {
        
        guard let index = shapes.firstIndex(of: shape) else { return }
        
        shapes.remove(at: index)
    }
}

extension SDFGrid {
    
    func sample(region: Euclid.Vector) -> Double {
        
        var value = 0.0
        
        for shape in shapes {
            
            value = min(value, shape.sample(region: region))
        }
        
        return value
    }
}
