//
//  FlatRoof.swift
//
//  Created by Zack Brown on 22/07/2021.
//

import Euclid
import Foundation
import Meadow

struct FlatRoof: Prop {
    
    let configuration: [Coordinate : GridPattern<Building.Element>]
    
    let height: Double
    
    let inset: Double
    
    let angled: Bool
    
    let textureCoordinates: UVs
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        let outer = BuildingShell(configuration: configuration, layers: 1, height: height, cornerInset: 0.01, edgeInset: 0.05, angled: angled, textureCoordinates: textureCoordinates)
        
        let inner = BuildingShell(configuration: configuration, layers: 1, height: height, cornerInset: 0.1, edgeInset: 0.1, angled: angled, textureCoordinates: textureCoordinates)
        
        var mesh = Mesh(outer.build(position: position))
        
        mesh = mesh.subtract(Mesh(inner.build(position: position + Vector(0, height / 4, 0))))
        
        return mesh.polygons
    }
}
