//
//  Prefab.swift
//
//  Created by Zack Brown on 19/01/2022.
//

import Euclid
import Meadow

protocol Prefab {
    
    func mesh(position: Vector, size: Vector) -> Mesh
}
