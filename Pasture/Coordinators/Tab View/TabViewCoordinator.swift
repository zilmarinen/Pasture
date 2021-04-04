//
//  TabViewCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class TabViewCoordinator: Coordinator<TabViewController> {
    
    @objc enum Tab: Int {
        
        case empty
    }
    
    override init(controller: TabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
