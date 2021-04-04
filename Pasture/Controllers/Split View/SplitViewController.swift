//
//  SplitViewController.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class SplitViewController: NSSplitViewController {
    
    enum Constants {
            
        static var openPanelWidth: CGFloat = 350.0
        static var closedPanelWidth: CGFloat = 0.0
    }
    
    @objc enum Panel: Int {
        
        case graph
        case model
        case inspector
    }
    
    enum Divider: Int {
     
        case left
        case right
    }
    
    weak var coordinator: SplitViewCoordinator?
    
    var graphViewController: GraphViewController? {
        
        return children.first { type(of: $0) == GraphViewController.self } as? GraphViewController
    }
    
    var modelViewController: ModelViewController? {
        
        return children.first { type(of: $0) == ModelViewController.self } as? ModelViewController
    }
    
    var inspectorViewController: InspectorViewController? {
        
        return children.first { type(of: $0) == InspectorViewController.self } as? InspectorViewController
    }
}

extension SplitViewController {
    
    override func toggle(splitView panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        let width = splitView.isSubviewCollapsed(subview) ? Constants.openPanelWidth : Constants.closedPanelWidth
        
        switch panel {
        
        case .graph:
            
            splitView.setPosition(width, ofDividerAt: Divider.left.rawValue)
            
        case .inspector:
            
            splitView.setPosition((CGFloat(splitView.frame.width) - width), ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
}
