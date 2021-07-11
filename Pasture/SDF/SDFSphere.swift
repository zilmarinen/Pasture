//
//  SDFSphere.swift
//
//  Created by Zack Brown on 27/06/2021.
//

import Euclid
import Foundation

public class SDFSphere: SDFShape {
    
    let radius: Double
    
    public init(position: Vector, radius: Double) {
        
        self.radius = radius
        
        super.init(position: position)
    }
    
    override func sample(region: Vector) -> Double {
        
        return (position - region).length - radius
    }
}

extension SDFSphere {
    
    public static func == (lhs: SDFSphere, rhs: SDFSphere) -> Bool {
        
        return  lhs.position == rhs.position &&
                lhs.radius == rhs.radius
    }
}
