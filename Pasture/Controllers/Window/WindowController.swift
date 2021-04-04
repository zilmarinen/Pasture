//
//  WindowController.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class WindowController: NSWindowController {
    
    var splitViewController: SplitViewController? { contentViewController as? SplitViewController }
    
    weak var coordinator: WindowCoordinator?
    
    @IBAction func segmentedControl(_ sender: NSSegmentedControl) {
        
        coordinator?.toggle(splitView: (sender.selectedSegment == 0 ? .graph : .inspector))
    }
}
