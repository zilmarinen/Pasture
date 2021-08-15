//
//  Edge.swift
//
//  Created by Zack Brown on 10/08/2021.
//

import Euclid
import Foundation
import Meadow

struct Edge: Prop {
    
    enum Side {
        
        case left
        case right
    }
    
    let style: WallTileMaterial
    
    let side: Side
    
    let external: Bool
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch style {
            
        case .concrete:
            
            let edge = ConcreteEdge(side: side, external: external)
            
            return edge.build(position: position)
            
        case .picket:
            
            let edge = PicketWall(cardinal: .east)
            
            return edge.build(position: position)
        }
    }
}
