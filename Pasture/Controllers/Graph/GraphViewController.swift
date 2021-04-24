//
//  GraphViewController.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class GraphViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet var treeController: NSTreeController!
    
    @IBOutlet var primitiveMenu: NSMenu!
    
    @IBOutlet weak var groupMenuItem: NSMenuItem!
    
    @IBOutlet weak var circleMenuItem: NSMenuItem!
    @IBOutlet weak var quadMenuItem: NSMenuItem!
    
    @IBOutlet weak var coneMenuItem: NSMenuItem!
    @IBOutlet weak var cubeMenuItem: NSMenuItem!
    @IBOutlet weak var cylinderMenuItem: NSMenuItem!
    @IBOutlet weak var sphereMenuItem: NSMenuItem!
    
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let event = NSApplication.shared.currentEvent else { return }
        
        switch sender {
        
        case addButton:
            
            NSMenu.popUpContextMenu(primitiveMenu, with: event, for: sender)
            
        default: break
        }
    }
    
    @IBAction func menuItem(_ sender: NSMenuItem) {
        
        switch sender {
        
        case groupMenuItem:
            
            coordinator?.addGroup()
            
        case circleMenuItem:
            
            coordinator?.add(primitive: .circle)
            
        case quadMenuItem:
            
            coordinator?.add(primitive: .quad)
        
        case coneMenuItem:
            
            coordinator?.add(primitive: .cone)
            
        case cubeMenuItem:
            
            coordinator?.add(primitive: .cube)
            
        case cylinderMenuItem:
            
            coordinator?.add(primitive: .cylinder)
            
        case sphereMenuItem:
            
            coordinator?.add(primitive: .sphere)
            
        default: break
        }
    }
    
    weak var coordinator: GraphCoordinator?
}
