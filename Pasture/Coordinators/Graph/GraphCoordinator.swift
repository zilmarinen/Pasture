//
//  GraphCoordinator.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa

class GraphCoordinator: Coordinator<GraphViewController> {
    
    enum Constants {
        
        static let pasteboardType = NSPasteboard.PasteboardType(rawValue: "com.so.pasture.groupNode")
    }
    
    override init(controller: GraphViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let model = option as? ModelNode else { fatalError("Invalid start option") }
        
        controller.outlineView.delegate = self
        controller.outlineView.dataSource = self
        controller.outlineView.registerForDraggedTypes([Constants.pasteboardType])
        
        controller.treeController.content = model
    }
}

extension GraphCoordinator: NSOutlineViewDelegate {
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let outlineView = notification.object as? NSOutlineView,
              let item = outlineView.item(atRow: outlineView.selectedRow) as? NSTreeNode,
              let node = item.representedObject as? GroupNode else { return }
        
        focus(node: node)
    }
}

extension GraphCoordinator: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        
        guard let item = item as? NSTreeNode,
              let node = item.representedObject as? GroupNode,
              node.ancestor != nil else { return .none }
        
        let pasteboardItem = NSPasteboardItem()
        
        pasteboardItem.setString(node.identifier, forType: Constants.pasteboardType)
        
        return pasteboardItem
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        
        guard let types = info.draggingPasteboard.types,
              types.contains(Constants.pasteboardType),
              item != nil else { return [] }
        
        return .move
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        
        guard let identifier = info.draggingPasteboard.string(forType: Constants.pasteboardType),
              let item = item as? NSTreeNode,
              let parentNode = item.representedObject as? GroupNode,
              let itemToMove = model?.find(child: identifier),
              let ancestor = itemToMove.ancestor as? GroupNode,
              itemToMove != parentNode else { return false }
        
        let index = index == NSOutlineViewDropOnItemIndex ? 0 : index
        
        ancestor.remove(child: itemToMove)
        
        if index < parentNode.childCount {
        
            parentNode.add(child: itemToMove, atIndex: index)
        }
        else {
            
            parentNode.add(child: itemToMove)
        }
        
        controller.treeController.rearrangeObjects()
        
        return true
    }
}
