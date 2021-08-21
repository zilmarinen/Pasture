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
        
        let nodes = scene.map.bridges.childNodes +
                    scene.map.buildings.childNodes +
                    scene.map.foliage.childNodes +
                    scene.map.stairs.childNodes +
                    scene.map.walls.childNodes
        
        for node in nodes {
            
            node.removeFromParentNode()
        }
        
        switch model.tool {
            
        case .bridge(let model):
            
            let node = BridgeModel(model: model)
            
            scene.map.bridges.addChildNode(node)
            
            node.clean()
            
        case .building(let model):
            
            let node = BuildingModel(model: model)
            
            scene.map.buildings.addChildNode(node)
            
            node.clean()
            
        case .bush:

            scene.map.foliage.addChildNode(TreeModel(model: model.tree))
            
        case .rock(let model):
            
            let node = RockModel(model: model)
            
            scene.map.foliage.addChildNode(node)
            
            node.clean()
            
        case .stairs(let model):
            
            let node = StairsModel(model: model)
            
            scene.map.stairs.addChildNode(node)
            
            node.clean()
            
        case .tree(let model):
            
            let node = TreeModel(model: model)
            
            scene.map.foliage.addChildNode(node)
            
            node.clean()
            
        case .walls(let model):
            
            let node = WallModel(model: model)
            
            scene.map.walls.addChildNode(node)
            
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
        
        switch model.tool {
            
        case .bridge(let model):
            
            let panel = NSOpenPanel()
            
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
            panel.canCreateDirectories = true
            panel.prompt = "Export"
            panel.title = "Export"
            
            panel.begin { (response) in
                
                guard response == .OK, let url = panel.urls.first else { return }
                
                let footprint = Footprint(coordinate: .zero, nodes: [.zero])
                
                let cornerLeft = BridgeCorner(material: model.material, side: .left, cardinals: [.east])
                let cornerRight = BridgeCorner(material: model.material, side: .right, cardinals: [.east])
                let cornerDual = BridgeCorner(material: model.material, side: .left, cardinals: [.south, .west])
                let edgeLeft = BridgeEdge(material: model.material, side: .left)
                let edgeRight = BridgeEdge(material: model.material, side: .right)
                let wall = BridgeWall(material: model.material)
                let path = BridgePath(material: model.material, cardinals: [])
                
                let models = ["\(model.material.id)_bridge_corner_left" : Asset(footprint: footprint, polygons: cornerLeft.build(position: .zero)),
                              "\(model.material.id)_bridge_corner_right" : Asset(footprint: footprint, polygons: cornerRight.build(position: .zero)),
                              "\(model.material.id)_bridge_corner_dual" : Asset(footprint: footprint, polygons: cornerDual.build(position: .zero)),
                              "\(model.material.id)_bridge_edge_left" : Asset(footprint: footprint, polygons: edgeLeft.build(position: .zero)),
                              "\(model.material.id)_bridge_edge_right" : Asset(footprint: footprint, polygons: edgeRight.build(position: .zero)),
                              "\(model.material.id)_bridge_wall" : Asset(footprint: footprint, polygons: wall.build(position: .zero)),
                              "\(model.material.id)_bridge_path" : Asset(footprint: footprint, polygons: path.build(position: .zero))]
                
                let encoder = JSONEncoder()
                
                var wrappers: [String : FileWrapper] = [:]
                
                for (identifier, asset) in models {
                    
                    guard let data = try? encoder.encode(asset) else { continue }
                    
                    wrappers["\(identifier).model"] = FileWrapper(regularFileWithContents: data)
                }
                
                let wrapper = FileWrapper(directoryWithFileWrappers: wrappers)
                
                try? wrapper.write(to: url, options: .atomic, originalContentsURL: nil)
            }
            
        case .stairs(let model):
            
            let panel = NSOpenPanel()
            
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
            panel.canCreateDirectories = true
            panel.prompt = "Export"
            panel.title = "Export"
            
            panel.begin { (response) in
                
                guard response == .OK, let url = panel.urls.first else { return }
                
                let encoder = JSONEncoder()
                
                var wrappers: [String : FileWrapper] = [:]
                
                for tileType in StairType.allCases {
                    
                    let stairs = Stairs(style: tileType, material: model.material)
                    
                    let asset = Asset(footprint: tileType.footprint, polygons: stairs.build(position: .zero))
                    
                    guard let data = try? encoder.encode(asset) else { continue }
                    
                    wrappers["\(model.material)_\(tileType.id).model"] = FileWrapper(regularFileWithContents: data)
                }
                
                let wrapper = FileWrapper(directoryWithFileWrappers: wrappers)
                
                try? wrapper.write(to: url, options: .atomic, originalContentsURL: nil)
            }
            
        case .walls(let model):
            
            let panel = NSOpenPanel()
            
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
            panel.canCreateDirectories = true
            panel.prompt = "Export"
            panel.title = "Export"
            
            panel.begin { (response) in
                
                guard response == .OK, let url = panel.urls.first else { return }
                
                let footprint = Footprint(coordinate: .zero, nodes: [.zero])
                
                let corner1 = Corner(style: model.style, cardinals: [.north])
                let corner2 = Corner(style: model.style, cardinals: [.north, .east])
                let corner3 = Corner(style: model.style, cardinals: [.north, .east, .south])
                let corner4 = Corner(style: model.style, cardinals: Cardinal.allCases)
                
                let edgeExternalLeft = Edge(style: model.style, side: .left, external: true)
                let edgeExternalRight = Edge(style: model.style, side: .right, external: true)
                let edgeInternal = Edge(style: model.style, side: .left, external: false)
                
                let wallExternal = Wall(style: model.style, external: true)
                let wallInternal = Wall(style: model.style, external: false)
                
                let models = ["\(model.style.id)_corner_1" : Asset(footprint: footprint, polygons: corner1.build(position: .zero)),
                              "\(model.style.id)_corner_2" : Asset(footprint: footprint, polygons: corner2.build(position: .zero)),
                              "\(model.style.id)_corner_3" : Asset(footprint: footprint, polygons: corner3.build(position: .zero)),
                              "\(model.style.id)_corner_4" : Asset(footprint: footprint, polygons: corner4.build(position: .zero)),
                              "\(model.style.id)_edge_external_left" : Asset(footprint: footprint, polygons: edgeExternalLeft.build(position: .zero)),
                              "\(model.style.id)_edge_external_right" : Asset(footprint: footprint, polygons: edgeExternalRight.build(position: .zero)),
                              "\(model.style.id)_edge_internal" : Asset(footprint: footprint, polygons: edgeInternal.build(position: .zero)),
                              "\(model.style.id)_wall_external" : Asset(footprint: footprint, polygons: wallExternal.build(position: .zero)),
                              "\(model.style.id)_wall_internal" : Asset(footprint: footprint, polygons: wallInternal.build(position: .zero))]
                
                let encoder = JSONEncoder()
                
                var wrappers: [String : FileWrapper] = [:]
                
                for (identifier, asset) in models {
                    
                    guard let data = try? encoder.encode(asset) else { continue }
                    
                    wrappers["\(identifier).model"] = FileWrapper(regularFileWithContents: data)
                }
                
                let wrapper = FileWrapper(directoryWithFileWrappers: wrappers)
                
                try? wrapper.write(to: url, options: .atomic, originalContentsURL: nil)
            }
            
        default:
            
            let panel = NSSavePanel()

            panel.canCreateDirectories = true
            panel.prompt = "Export"
            panel.title = "Export"
            panel.nameFieldStringValue = "\(model.name).model"
            
            panel.begin { (response) in
                
                guard response == .OK, let url = panel.url else { return }
                
                var asset: Asset?
                
                switch model.tool {
                    
                case .building(let model): asset = Asset(footprint: model.footprint, polygons: model.build(position: .zero))
                case .rock(let model): asset = Asset(footprint: model.footprint, polygons: model.build(position: .zero))
                case .tree(let model): asset = Asset(footprint: model.footprint, polygons: model.build(position: .zero))
                    
                default: break
                }
                
                guard let asset = asset else { return }
                
                let data = try? JSONEncoder().encode(asset)
                
                try? data?.write(to: url, options: .atomic)
            }
        }
    }
}
