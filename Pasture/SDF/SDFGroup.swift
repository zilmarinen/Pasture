//
//  SDFGroup.swift
//
//  Created by Zack Brown on 10/07/2021.
//

import Euclid

class SDFGroup: SDFShape {
    
    var shapes: [SDFShape]
    
    init(shapes: [SDFShape] = []) {
        
        self.shapes = shapes
        
        super.init(position: .zero)
    }
    
    override func sample(region: Vector) -> Double {
        
        var value = 0.0
        
        for shape in shapes {
            
            value = min(shape.sample(region: region), value)
        }
        
        return value
    }
}

extension SDFGroup {
    
    public func add(shape: SDFShape) {
        
        guard !shapes.contains(shape) else { return }
        
        shapes.append(shape)
    }
    
    public func remove(shape: SDFShape) {
        
        guard let index = shapes.firstIndex(of: shape) else { return }
        
        shapes.remove(at: index)
    }
}
