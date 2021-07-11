//
//  SDFGroup.swift
//
//  Created by Zack Brown on 10/07/2021.
//

import Euclid

class SDFGroup: SDFShape {
    
    enum Method {
        
        case additive
        case minimum
        case maximum
    }
    
    let method: Method
    let shapes: [SDFShape]
    
    init(method: Method, shapes: [SDFShape]) {
        
        self.method = method
        self.shapes = shapes
        
        super.init(position: .zero)
    }
    
    override func sample(region: Vector) -> Double {
        
        var value = 0.0
        
        for shape in shapes {
            
            switch method {
                
            case .additive:
                
                value += (shape.sample(region: region) / Double(shapes.count))
                
            case .minimum:
                
                value = min(shape.sample(region: region), value)
                
            case .maximum:
                
                value = max(shape.sample(region: region), value)
            }
        }
        
        return value
    }
}
