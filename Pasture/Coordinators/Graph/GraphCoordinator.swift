//
//  GraphCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class GraphCoordinator: Coordinator<GraphViewController> {
    
    override init(controller: GraphViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
