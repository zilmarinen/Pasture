//
//  Document.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Cocoa
import SpriteKit

class Document: NSDocument {
    
    enum Constants {
        
        static let windowIndentifier = NSStoryboard.SceneIdentifier("WindowController")
        
        static let meshWrapperIdentifier = "prop.mesh"
        static let modelWrapperIdentifier = "model.graph"
        static let textureWrapperIdentifier = "texture.png"
    }
    
    let coordinator: WindowCoordinator
    
    var model: ModelNode?

    override init() {
        
        guard let windowController = NSStoryboard.main.instantiateController(withIdentifier: Constants.windowIndentifier) as? WindowController else { fatalError("Invalid view controller hierarchy") }
        
        coordinator = WindowCoordinator(controller: windowController)
        
        super.init()
    }

    override class var autosavesInPlace: Bool {
        
        return true
    }

    override func makeWindowControllers() {
        
        self.addWindowController(coordinator.controller)
        
        coordinator.start(with: model)
        
        model = nil
    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        guard let modelGraph = fileWrapper.fileWrappers?.first(where: { $0.key == Constants.modelWrapperIdentifier })?.value.regularFileContents else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }
        
        let decoder = JSONDecoder()
        
        model = try decoder.decode(ModelNode.self, from: modelGraph)
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        guard let model = coordinator.splitViewCoordinator.modelCoordinator.currentModel,
              let mesh = model.mesh else { throw NSError(domain: NSOSStatusErrorDomain, code: writErr, userInfo: nil) }
        
        var wrappers: [String : FileWrapper] = [:]
        
        let encoder = JSONEncoder()
        
        let modelJSON = Model(footprint: model.footprint, polygons: mesh.polygons)
        
        let modelGraph = try encoder.encode(model)
        let meshGraph = try encoder.encode(modelJSON)
        
        wrappers[Constants.meshWrapperIdentifier] = FileWrapper(regularFileWithContents: meshGraph)
        wrappers[Constants.modelWrapperIdentifier] = FileWrapper(regularFileWithContents: modelGraph)
        
        return FileWrapper(directoryWithFileWrappers: wrappers)
    }
}
