//
//  SDFShape.swift
//
//  Created by Zack Brown on 25/06/2021.
//

import Euclid
import Foundation

public class SDFShape: SDFSampler {
    
    let position: Vector
    
    init(position: Vector) {
        
        self.position = position
    }
    
    func sample(region: Vector) -> Double { fatalError("SDFShape.sample(region:) must be overridden") }
}

extension SDFShape: Equatable {
    
    public static func == (lhs: SDFShape, rhs: SDFShape) -> Bool {
        
        return lhs.position == rhs.position
    }
}
