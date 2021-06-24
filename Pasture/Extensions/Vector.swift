//
//  Vector.swift
//
//  Created by Zack Brown on 14/06/2021.
//

import Euclid

extension Vector {
    
    static let zero = Vector(0, 0, 0)
    static let one = Vector(1, 1, 1)
    static var right =  Vector(1, 0, 0)
    static var up = Vector(0, 1, 0)
    static var forward = Vector(0, 0, -1)
    static var infinity = Vector(.infinity, .infinity, .infinity)
}

extension Array where Element == Vector {
    
    func normal() -> Vector {
        
        var v0 = self.first!
        var v1: Vector?
        
        var ab = v0 - self.last!
        
        var magnitude = 0.0
        
        for vector in self {
            
            let bc = vector - v0
            
            let normal = ab.cross(bc)
            
            let squaredMagnitude = normal.lengthSquared
            
            if squaredMagnitude > magnitude {
                
                magnitude = squaredMagnitude
                
                v1 = normal / squaredMagnitude.squareRoot()
            }
            
            v0 = vector
            ab = bc
        }
        
        return v1 ?? Vector(0, 1, 0)
    }
}
