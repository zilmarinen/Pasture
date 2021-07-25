//
//  SaltboxRoof.swift
//
//  Created by Zack Brown on 23/07/2021.
//

import Euclid
import Foundation
import Meadow

struct SaltboxRoof: Prop {
    
    enum Peak {
        
        case left
        case center
        case right
        
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
    
    let height: Double
    let slope: Double
    
    let direction: Cardinal
    let peak: Peak
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        var corners = [position + Euclid.Vector(Double(footprint.bounds.end.x) + 0.5, 0, Double(footprint.bounds.start.z) - 0.5),
                       position + Euclid.Vector(Double(footprint.bounds.start.x) - 0.5, 0, Double(footprint.bounds.start.z) - 0.5),
                       position + Euclid.Vector(Double(footprint.bounds.start.x) - 0.5, 0, Double(footprint.bounds.end.z) + 0.5),
                       position + Euclid.Vector(Double(footprint.bounds.end.x) + 0.5, 0, Double(footprint.bounds.end.z) + 0.5)]
        
        let uvs = [Euclid.Vector(0, 0, 0),
                   Euclid.Vector(0, 1, 0),
                   Euclid.Vector(1, 1, 0),
                   Euclid.Vector(1, 0, 0)]
        
        switch direction {
            
        case .east,
            .west:
            
            corners = [corners[1], corners[2], corners[3], corners[0]]
            
        default: break
        }
        
        let v0 = corners[0].lerp(corners[1], peak.length) + Vector(0, slope, 0)
        let v1 = corners[3].lerp(corners[2], peak.length) + Vector(0, slope, 0)
        
        guard let lhs = polygon(vectors: [corners[0], v0, v1, corners[3]], uvs: uvs),
              let rhs = polygon(vectors: [v0, corners[1], corners[2], v1], uvs: uvs) else { return [] }
        
        return [lhs, rhs]
    }
}
