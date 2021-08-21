//
//  BridgePath.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct BridgePath: Prop {
    
    let material: BridgeMaterial

    let cardinals: [Cardinal]
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch material {
            
        case .stone:
            
            let corner = StoneBridgePath(cardinals: cardinals)
            
            return corner.build(position: position)
        }
    }
}
