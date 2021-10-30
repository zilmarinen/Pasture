//
//  Wall.swift
//
//  Created by Zack Brown on 10/08/2021.
//

import Euclid
import Foundation
import Meadow

struct Wall: Prop {
    
    let style: WallMaterial
    
    let external: Bool
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch style {
            
        case .concrete:
            
            let wall = ConcreteWall(external: external)
            
            return wall.build(position: position)
            
        case .picket:
            
            let wall = PicketWall(cardinal: .north)
            
            return wall.build(position: position)
        }
    }
}
