//
//  Prototype.swift
//
//  Created by Zack Brown on 24/10/2021.
//

import Euclid
import Harvest
import Meadow

protocol PrototypeFoliage {
    
    var species: Species { get }
    
    var mesh: Mesh { get }
}

struct Prototype: PrototypeFoliage {
    
    enum Constants {
        
        //
    }
    
    let species: Species
    let footprint: Wireframe.Footprint
    
    var mesh: Mesh { prototype.mesh }
}

extension Prototype {
    
    var prototype: PrototypeFoliage {
        
        switch species {
            
        case .bamboo: return PrototypeBamboo(footprint: footprint)
        case .cherryBlossom: return PrototypeCherryBlossom(footprint: footprint)
        case .gingko: return PrototypeGingko(footprint: footprint)
        case .hebe: return PrototypeHebe(footprint: footprint)
        }
    }
}
