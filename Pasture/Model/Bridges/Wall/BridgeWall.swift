//
//  BridgeWall.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import Meadow

struct BridgeWall: Prop {
    
    let material: BridgeMaterial
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch material {
            
        case .stone:
            
            let corner = StoneBridgeWall()
            
            return corner.build(position: position)
        }
    }
}
