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
        
        switch model.tool {
            
        case .building,
                .bush:
            
            for node in scene.meadow.foliage.childNodes {
                
                node.removeFromParentNode()
            }
            
            scene.meadow.foliage.addChildNode(TreeModel(model: model.tree))
            
        case .rock(let rock):
            
            for node in scene.meadow.foliage.childNodes {
                
                node.removeFromParentNode()
            }
            
            let node = RockModel(model: rock)
            
            scene.meadow.foliage.addChildNode(node)
            
            node.clean()
            
        case .tree(let tree):
            
            for node in scene.meadow.foliage.childNodes {
                
                node.removeFromParentNode()
            }
            
            let node = TreeModel(model: tree)
            
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
                
            case .building,
                    .bush:
                
                print("")
                
            case .rock(let rock):
                
                let asset = Asset(footprint: rock.footprint, polygons: rock.build(position: .zero))
                
                let data = try? JSONEncoder().encode(asset)
                
                try? data?.write(to: url, options: .atomic)
                
            case .tree(let tree):
                
                let asset = Asset(footprint: tree.footprint, polygons: tree.build(position: .zero))
                
                let data = try? JSONEncoder().encode(asset)
                
                try? data?.write(to: url, options: .atomic)
            }
        }
    }
}
