//
//  StairsModel.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Euclid
import Meadow
import SceneKit

class StairsModel: SCNNode, Responder, Shadable, Soilable {
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = true
    
    public var category: Int { SceneGraphCategory.stairChunk.rawValue }
    
    public var program: SCNProgram? { scene?.map.stairs.program }
    public var uniforms: [Uniform]? { nil }
    public var textures: [Texture]? { nil }
    
    let model: Stairs
    
    init(model: Stairs) {
        
        self.model = model
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let mesh = Mesh(model.build(position: .zero))
        
        self.geometry = SCNGeometry(mesh)
        self.geometry?.program = program
        
        if let uniforms = uniforms {
            
            self.geometry?.set(uniforms: uniforms)
        }
        
        if let textures = textures {
            
            self.geometry?.set(textures: textures)
        }
        
        for child in childNodes {
            
            child.removeFromParentNode()
        }
        
        let node = SCNNode(geometry: SCNGeometry(wireframe: mesh))
        addChildNode(node)
        
        isDirty = false
        
        return true
    }
}
