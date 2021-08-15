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
    
    let architecture: Building.Architecture
    
    let height: Double
    
    let inset: Double
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        let roofTextureCoordinates = UVs(start: .zero, end: Vector(0.5, 0.5))
        let shingleTextureCoordinates = UVs(start: Vector(0.5, 0.0), end: Vector(1.0, 0.125))
        
        let outer = BuildingShell(configuration: configuration, architecture: architecture, layers: 1, height: height, inset: inset / 2.0, angled: architecture.angled, cornerStyle: .plain, cutaways: false, uvs: (shingleTextureCoordinates, shingleTextureCoordinates, roofTextureCoordinates))
        
        let inner = BuildingShell(configuration: configuration, architecture: architecture, layers: 1, height: height, inset: inset, angled: architecture.angled, cornerStyle: .plain, cutaways: false, uvs: (wallTextureCoordinates, wallTextureCoordinates, roofTextureCoordinates))
        
        var mesh = Mesh(outer.build(position: position))
        
        mesh = mesh.subtract(Mesh(inner.build(position: position + Vector(0, height / 4, 0))))
        
        return mesh.polygons
    }
}
