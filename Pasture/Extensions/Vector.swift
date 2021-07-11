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

extension Vector {
    
    static func *(lhs: Self, rhs: Self) -> Self {
        
        return Vector(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }
    
    static func minimum(lhs: Self, rhs: Self) -> Self {
        
        return Vector(min(lhs.x, rhs.x), min(lhs.y, rhs.y), min(lhs.z, rhs.z))
    }
    
    static func maximum(lhs: Self, rhs: Self) -> Self {
        
        return Vector(max(lhs.x, rhs.x), max(lhs.y, rhs.y), max(lhs.z, rhs.z))
    }
    
    static func absolute(vector: Vector) -> Vector {
        
        return Vector(abs(vector.x), abs(vector.y), abs(vector.z))
    }
}

extension Vector {
    
    var xz: Vector {
        
        return Vector(x, 0, z)
    }
}

extension Array where Element == Vector {
    
    func average() -> Vector {
        
        guard count > 0 else { return .zero }
        
        var x = 0.0
        var y = 0.0
        var z = 0.0
        
        for i in 0..<count {
            
            let vector = self[i]
            
            x += vector.x
            y += vector.y
            z += vector.z
        }
        
        return Vector(x / Double(count), y / Double(count), z / Double(count))
    }
    
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
