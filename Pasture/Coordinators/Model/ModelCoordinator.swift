//
//  ModelCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class ModelCoordinator: Coordinator<ModelViewController> {
    
    override init(controller: ModelViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
