//
//  ModelCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa
import Euclid
import Meadow
import SceneKit

class ModelCoordinator: Coordinator<ModelViewController> {
    
    var currentModel: ModelNode?
    
    override init(controller: ModelViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let model = option as? ModelNode else { fatalError("Invalid start option") }
        
        guard let sceneView = controller.scnView,
              let device = sceneView.device,
              let workspace = NSDataAsset(name: "workspace", bundle: .main) else { fatalError("Invalid scene view") }
        
        sceneView.library = try? device.makeDefaultLibrary(bundle: Meadow.bundle)
        
        currentModel = model
        
        let decoder = JSONDecoder()
        
        let scene = try? decoder.decode(Scene.self, from: workspace.data)
        
        scene?.meadow.actors.isHidden = true
        scene?.rootNode.addChildNode(model)
        
        sceneView.delegate = self
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.isPlaying = true
    }
}

extension ModelCoordinator: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        currentModel?.clean()
        
        guard let scene = sceneView?.scene as? Scene else { return }
        
        scene.renderer(renderer, updateAtTime: time)
    }
}

extension ModelCoordinator {
    
    override func focus(node: GroupNode) {
        
        guard let scene = sceneView?.scene as? Scene else { return }
        
        scene.camera.controller.focus(node: node)
        
        guard let model = currentModel else { return }
        
        model.select(node: node)
    }
    
    override func addGroup() {
        
        guard let model = currentModel else { return }
        
        let group = GroupNode()
        
        model.add(child: group, atIndex: 0)
        
    }
    
    override func add(primitive: Primitive.RawType) {
        
        guard let model = currentModel else { return }
        
        var shape: GroupNode?
        
        switch primitive {
        
        case .circle:
            
            shape = GroupNode(primitive: .circle(radius: 1, slices: 8))
            
        case .quad:
            
            shape = GroupNode(primitive: .quad(width: 1, height: 1))
        
        case .cone:
            
            shape = GroupNode(primitive: .cone(radius: 1, height: 1, slices: 8, poleDetail: 0))
            
        case .cube:
            
            shape = GroupNode(primitive: .cube(size: Euclid.Vector(1, 1, 1)))
            
        case .cylinder:
            
            shape = GroupNode(primitive: .cylinder(radius: 1, height: 1, slices: 8, poleDetail: 0))
            
        case .sphere:
            
            shape = GroupNode(primitive: .sphere(radius: 1, slices: 8, stacks: 8, poleDetail: 0))
        }
        
        guard let child = shape else { return }
        
        model.add(child: child)
    }
}
