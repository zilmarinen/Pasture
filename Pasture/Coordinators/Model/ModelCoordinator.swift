//
//  ModelCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class ModelCoordinator: Coordinator<ModelViewController> {
    
    var currentModel: Model?
    
    override init(controller: ModelViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let model = option as? Model else { fatalError("Invalid start option") }
        
        currentModel = model
    }
}
