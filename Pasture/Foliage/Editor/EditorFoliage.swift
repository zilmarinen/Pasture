//
//  EditorFoliage.swift
//
//  Created by Zack Brown on 31/10/2021.
//

import Combine
import Euclid
import Harvest
import Meadow

class EditorFoliage: ObservableObject {
    
    @Published var footprint: Wireframe.Footprint = .x1
    
    @Published var species: Species = .bamboo
    
    var prototype: PrototypeFoliage { Prototype(species: species, footprint: footprint) }
    
    var mesh: Mesh { prototype.mesh }
}
