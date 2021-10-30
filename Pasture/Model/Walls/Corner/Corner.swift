//
//  Corner.swift
//
//  Created by Zack Brown on 10/08/2021.
//

import Euclid
import Foundation
import Meadow

struct Corner: Prop {
    
    let style: WallMaterial
    
    let cardinals: [Cardinal]
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch style {
            
        case .concrete:
            
            let corner = ConcreteCorner()
            
            return corner.build(position: position)
            
        case .picket:
            
            let corner = PicketCorner(cardinals: cardinals)
            
            return corner.build(position: position)
        }
    }
}
