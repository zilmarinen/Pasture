//
//  ContentView.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import Meadow
import SceneKit
import SwiftUI

struct ContentView: View {
    
    @Binding var document: PastureDocument
    
    var scene: MDWScene

    var body: some View {
        
        HSplitView {
            
            ModelView(model: $document.model, scene: scene)
            .frame(minWidth: 350,
                   minHeight: 350)
            
            ScrollView {
                
                VStack(alignment: .leading)  {
                    
                    GroupBox {
                    
                        ModelPropertiesView(model: $document.model)
                    }
                    
                    switch document.model.tool {
                        
                    case .bridge:
                        
                        BridgeView(bridge: $document.model.bridge)
                        
                    case .building:
                        
                        BuildingView(building: $document.model.building)
                        
                    case .bush:
                        
                        BushView()
                        
                    case .rock:
                        
                        RockView(rock: $document.model.rock)
                        
                    case .stairs:
                        
                        StairsView(stairs: $document.model.stairs)
                        
                    case .tree:
                        
                        TreeView(tree: $document.model.tree)
                        
                    case .walls:
                        
                        WallView(walls: $document.model.walls)
                    }
                }
                .padding()
            }
            .toolbar {
                
                ToolView(tool: $document.model.tool)
            }
            .frame(minWidth: 280, maxWidth: 280)
        }
        .controlSize(.small)
    }
}
