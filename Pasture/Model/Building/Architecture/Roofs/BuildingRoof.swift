//
//  BuildingRoof.swift
//
//  Created by Zack Brown on 22/07/2021.
//

import Euclid
import Foundation
import Meadow

struct BuildingRoof: Prop {
    
    enum Style {
        
        case flat(inset: Double, angled: Bool)
        case hip(direction: Cardinal)
        case jerkinhead(direction: Cardinal)
        case mansard(direction: Cardinal)
        case saltbox(direction: Cardinal, peak: SaltboxRoof.Peak)
        case skillion(direction: Cardinal)
    }
    
    let footprint: Footprint
    
    let configuration: [Coordinate : GridPattern<Building.Element>]
    
    let style: Style
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        switch style {
            
        case .flat(let inset, let angled):
            
            let roof = FlatRoof(configuration: configuration, height: World.Constants.slope / 2, inset: inset, angled: angled, textureCoordinates: UVs(start: .zero, end: .one))
            
            return roof.build(position: position)
            
        case .saltbox(let direction, let peak):
            
            let roof = SaltboxRoof(footprint: footprint, configuration: configuration, height: World.Constants.slope / 4, slope: World.Constants.slope, direction: direction, peak: peak)
            
            return roof.build(position: position)
        
        default: return []
        }
    }
}
