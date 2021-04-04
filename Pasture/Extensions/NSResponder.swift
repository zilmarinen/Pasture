//
//  NSResponder.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

@objc extension NSResponder {
    
    func toggle(splitView panel: SplitViewController.Panel) { responder?.toggle(splitView: panel) }
    
    var responder: NSResponder? { nextResponder }
}
