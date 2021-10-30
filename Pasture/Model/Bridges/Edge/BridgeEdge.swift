//
//  BridgeEdge.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct BridgeEdge: Prop {
    
    enum Side {
        
        case left
        case right
    }
    
    let material: BridgeMaterial
    
    let side: Side
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch material {
            
        case .stone:
            
            let corner = StoneBridgeEdge(side: side)
            
            return corner.build(position: position)
            
        default: return []
        }
    }
}
