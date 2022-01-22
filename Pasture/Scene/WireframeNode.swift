//
//  WireframeNode.swift
//
//  Created by Zack Brown on 30/10/2021.
//

import Euclid
import Meadow
import SceneKit

class WireframeNode: SCNNode {
    
    init(position: SCNVector3, size: Vector) {
        
        super.init()
        
        self.position = position
        self.geometry = SCNGeometry(wireframe: Mesh.cube(center: .zero, size: size, faces: .default, material: MDWColor.black))
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class Wireframe: SCNNode {
    
    enum Footprint: CaseIterable, Identifiable {
        
        case x1
        case x2
        case x3
        
        var id: String {
            
            switch self {
                
            case .x1: return "1x1"
            case .x2: return "2x2"
            case .x3: return "3x3"
            }
        }
        
        var size: Vector {
            
            switch self {
                
            case .x1: return Vector(x: 1, y: 1, z: 1)
            case .x2: return Vector(x: 2, y: 2, z: 2)
            case .x3: return Vector(x: 3, y: 3, z: 3)
            }
        }
    }
    
    var footprint: Footprint {
        
        didSet {
            
            layout()
        }
    }
    
    init(footprint: Footprint) {
        
        self.footprint = footprint
        
        super.init()
        
        layout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func layout() {
        
        for child in childNodes {
            
            child.removeFromParentNode()
        }
        
        let size = footprint.size
        
        addChildNode(WireframeNode(position: SCNVector3(x: 0, y: size.y / 2.0, z: 0), size: size))
        addChildNode(WireframeNode(position: SCNVector3(x: size.x / 4, y: size.y / 2.0, z: 0), size: Vector(x: size.x / 2.0, y: size.y, z: size.z)))
        addChildNode(WireframeNode(position: SCNVector3(x: 0, y: size.y / 4, z: 0), size: Vector(x: size.x, y: size.x / 2.0, z: size.z)))
        addChildNode(WireframeNode(position: SCNVector3(x: 0, y: size.y / 2.0, z: size.z / 4), size: Vector(x: size.x, y: size.y, z: size.z / 2.0)))
    }
}
