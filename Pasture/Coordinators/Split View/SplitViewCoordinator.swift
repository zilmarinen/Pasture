//
//  SplitViewCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa
import Meadow

class SplitViewCoordinator: Coordinator<SplitViewController> {
    
    lazy var graphCoordinator: GraphCoordinator = {
       
        guard let viewController = controller.graphViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = GraphCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var modelCoordinator: ModelCoordinator = {
       
        guard let viewController = controller.modelViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = ModelCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var inspectorCoordinator: InspectorCoordinator = {
       
        guard let viewController = controller.inspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = InspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SplitViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: graphCoordinator, with: option)
        start(child: modelCoordinator, with: option)
        start(child: inspectorCoordinator, with: option)
    }
}

extension SplitViewCoordinator {
    
    override var sceneView: SceneView? { modelCoordinator.controller.scnView }
    
    override var model: ModelNode? { modelCoordinator.currentModel }
    
    override func focus(node: GroupNode) {
        
        modelCoordinator.focus(node: node)
        inspectorCoordinator.tabViewCoordinator.toggle(inspector: .group, with: node)
    }
    
    override func addGroup() {
        
        modelCoordinator.addGroup()
        graphCoordinator.controller.treeController.rearrangeObjects()
    }
    
    override func add(primitive: Primitive.RawType) {
        
        modelCoordinator.add(primitive: primitive)
        graphCoordinator.controller.treeController.rearrangeObjects()
    }
}
