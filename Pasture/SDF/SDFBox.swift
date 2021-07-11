//
//  SDFBox.swift
//
//  Created by Zack Brown on 27/06/2021.
//

import Euclid
import Foundation

public class SDFBox: SDFShape {
    
    let size: Vector
    
    public init(position: Vector, size: Vector) {
        
        self.size = size
        
        super.init(position: position)
    }
    
    override func sample(region: Vector) -> Double {
        
        let q = Vector.absolute(vector: position - region) - size
        
        return Vector.maximum(lhs: q, rhs: .zero).length + min(max(q.x, q.y, q.z), 0.0)
    }
}

extension SDFBox {
    
    public static func == (lhs: SDFBox, rhs: SDFBox) -> Bool {
        
        return  lhs.position == rhs.position &&
                lhs.size == rhs.size
    }
}
