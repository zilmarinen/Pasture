//
//  BridgeCorner.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct BridgeCorner: Prop {
    
    let material: BridgeMaterial
    
    let side: BridgeEdge.Side
    
    let cardinals: [Cardinal]
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch material {
            
        case .stone:
            
            let corner = StoneBridgeCorner(side: side, cardinals: cardinals)
            
            return corner.build(position: position)
            
        default: return []
        }
    }
}
