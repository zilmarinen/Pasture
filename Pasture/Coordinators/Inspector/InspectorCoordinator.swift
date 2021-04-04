//
//  InspectorCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class InspectorCoordinator: Coordinator<InspectorViewController> {
    
    lazy var tabViewCoordinator: TabViewCoordinator = {
       
        guard let viewController = controller.tabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: InspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: tabViewCoordinator, with: option)
    }
}
