//
//  SDFLineSegment.swift
//
//  Created by Zack Brown on 28/06/2021.
//

import Euclid
import Foundation

public class SDFLineSegment: SDFShape {
    
    let radius: Double
    let length: Double
    
    public init(position: Vector, radius: Double, length: Double) {
        
        self.radius = radius
        self.length = length
        
        super.init(position: position)
    }
    
    override func sample(region: Vector) -> Double {
        
        let q = Vector(region.x, region.y - min(length, max(0.0, region.y)), region.z)
        
        return (position - q).length - radius
    }
}

extension SDFLineSegment {
    
    public static func == (lhs: SDFLineSegment, rhs: SDFLineSegment) -> Bool {
        
        return  lhs.position == rhs.position &&
                lhs.radius == rhs.radius &&
                lhs.length == rhs.length
    }
}
