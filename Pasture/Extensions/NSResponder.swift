//
//  NSResponder.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa
import Meadow

@objc extension NSResponder {
    
    func toggle(splitView panel: SplitViewController.Panel) { responder?.toggle(splitView: panel) }
    func toggle(inspector: TabViewCoordinator.Tab, with node: GroupNode) { responder?.toggle(inspector: inspector, with: node) }
    func focus(node: GroupNode) { responder?.focus(node: node) }
    
    func addGroup() { responder?.addGroup() }
    func add(primitive: Primitive.RawType) { responder?.add(primitive: primitive) }
    
    var responder: NSResponder? { nextResponder }
    
    var sceneView: SceneView? { responder?.sceneView }
    
    var model: ModelNode? { responder?.model }
}
