//
//  ModelView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import Euclid
import Meadow
import SceneKit
import SwiftUI

struct ModelView: View {
    
    @Binding var model: Model
    
    var scene: MDWScene
    
    var body: some View {
        
        for node in scene.meadow.buildings.childNodes {
            
            node.removeFromParentNode()
        }
        
        for node in scene.meadow.foliage.childNodes {
            
            node.removeFromParentNode()
        }
        
        switch model.tool {
            
        case .building(let model):
            
            let node = BuildingModel(model: model)
            
            scene.meadow.buildings.addChildNode(node)
            
            node.clean()
            
        case .bush:

            scene.meadow.foliage.addChildNode(TreeModel(model: model.tree))
            
        case .rock(let model):
            
            let node = RockModel(model: model)
            
            scene.meadow.foliage.addChildNode(node)
            
            node.clean()
            
        case .tree(let model):
            
            let node = TreeModel(model: model)
            
            scene.meadow.foliage.addChildNode(node)
            
            node.clean()
        }
        
        return SceneView(scene: scene,
                  options: [.allowsCameraControl],
                  delegate: scene)
            .toolbar {
                Spacer()
                Button(action: export) {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
            }
    }
}

extension ModelView {
    
    private func export() {
        
        let panel = NSSavePanel()

        panel.canCreateDirectories = true
        panel.prompt = "Export"
        panel.title = "Export"
        panel.nameFieldStringValue = "\(model.name).model"
        
        panel.begin { (response) in
            
            guard response == .OK, let url = panel.url else { return }
            
            switch model.tool {
                
            case .building(let model):
                
                let asset = Asset(footprint: model.footprint, polygons: model.build(position: .zero))
                
                let data = try? JSONEncoder().encode(asset)
                
                try? data?.write(to: url, options: .atomic)
                
            case .bush:
                
                print("")
                
            case .rock(let model):
                
                let asset = Asset(footprint: model.footprint, polygons: model.build(position: .zero))
                
                let data = try? JSONEncoder().encode(asset)
                
                try? data?.write(to: url, options: .atomic)
                
            case .tree(let model):
                
                let asset = Asset(footprint: model.footprint, polygons: model.build(position: .zero))
                
                let data = try? JSONEncoder().encode(asset)
                
                try? data?.write(to: url, options: .atomic)
            }
        }
    }
}
