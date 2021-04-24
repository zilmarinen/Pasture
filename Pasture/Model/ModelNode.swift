//
//  ModelNode.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Euclid
import Foundation
import Meadow
import SceneKit

class ModelNode: GroupNode {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
    }
    
    var footprint: Footprint
    
    init(name: String? = "Model") {
        
        footprint = Footprint(coordinate: .zero, rotation: .north, nodes: [.zero])
        
        super.init()
        
        self.name = name
        /*
        let building = GroupNode(primitive: .cube(size: Vector(1.8, 0.9, 1.8)))
        building.groupTransform = Euclid.Transform(offset: Euclid.Vector(0.5, 0.45, 0.5))
        building.name = "Building"
        
        let roof = GroupNode()
        roof.name = "Roof"
        
        let tiles = GroupNode(primitive: .cube(size: Vector(2.1, 2.1, 2)))
        tiles.groupTransform = Euclid.Transform(offset: Euclid.Vector(0.5, 0.4, 0.5), rotation: .roll(.halfPi / 2))
        tiles.name = "Tiles"
        
        let chimney = GroupNode(primitive: .cylinder(radius: 0.125, height: 0.5, slices: 8, poleDetail: 2))
        chimney.groupTransform = Euclid.Transform(offset: Euclid.Vector(0.5, 2, 0))
        chimney.name = "Chimney"
        
        roof.add(child: tiles, atIndex: 0)
        roof.add(child: chimney, atIndex: 1)
        
        let cutaway = GroupNode(primitive: .cube(size: Vector(3, 3, 3)))
        cutaway.groupTransform = Euclid.Transform(offset: Euclid.Vector(0.5, -0.6, 0.5))
        cutaway.operation = .subtract
        cutaway.name = "Cutaway"
        
        add(child: roof, atIndex: 0)
        add(child: cutaway, atIndex: 1)
        add(child: building, atIndex: 2)*/
        
        /*let cone = GroupNode(primitive: .cone(radius: 1, height: 1, slices: 8, poleDetail: 2))
        cone.groupTransform = Euclid.Transform(offset: Euclid.Vector(2, 2, 0))
        cone.name = "Cone"
        
        let cube = GroupNode(primitive: .cube(size: Vector(1, 1, 1)))
        cube.groupTransform = Euclid.Transform(offset: Euclid.Vector(-2, 2, 0))
        cube.name = "Cube"
        
        let cylinder = GroupNode(primitive: .cylinder(radius: 1, height: 1, slices: 8, poleDetail: 2))
        cylinder.groupTransform = Euclid.Transform(offset: Euclid.Vector(0, 2, 2))
        cylinder.name = "Cylinder"
        
        let sphere = GroupNode(primitive: .sphere(radius: 1, slices: 8, stacks: 8, poleDetail: 2))
        sphere.groupTransform = Euclid.Transform(offset: Euclid.Vector(0, 2, -2))
        sphere.name = "Sphere"
        
        add(child: cone)
        add(child: cube)
        add(child: cylinder)
        add(child: sphere)*/
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        footprint = try container.decode(Footprint.self, forKey: .footprint)
       
        try super.init(from: decoder)
    }
   
    required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }
   
    public override func encode(to encoder: Encoder) throws {
       
        try super.encode(to: encoder)
       
        var container = encoder.container(keyedBy: CodingKeys.self)
       
        try container.encode(footprint, forKey: .footprint)
    }
}
