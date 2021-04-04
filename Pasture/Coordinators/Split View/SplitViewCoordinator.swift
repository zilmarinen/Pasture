//
//  SplitViewCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

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
