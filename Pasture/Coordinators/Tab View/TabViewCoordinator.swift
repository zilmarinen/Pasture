//
//  TabViewCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class TabViewCoordinator: Coordinator<TabViewController> {
    
    @objc enum Tab: Int {
        
        case empty
        case group
    }
    
    lazy var groupInspectorCoordinator: GroupInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.group.rawValue] as? GroupInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = GroupInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: TabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabViewCoordinator {
    
    override func toggle(inspector: Tab, with node: GroupNode) {
        
        stopChildren()
        
        switch inspector {
        
        case .group:
            
            guard let polygon = node.mesh?.polygons.first,
                  polygon.vertices.first != nil else { return }
            
            let option = GroupInspectorCoordinator.ViewState.inspector(node: node, polygonIndex: 0, vertexIndex: 0)
            
            start(child: groupInspectorCoordinator, with: option)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = inspector.rawValue
    }
}
