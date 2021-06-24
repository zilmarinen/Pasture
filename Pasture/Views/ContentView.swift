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
                    
                    switch document.model.tool {
                        
                    case .building:
                        
                        BuildingView()
                        
                    case .bush:
                        
                        BushView()
                        
                    case .rock:
                        
                        RockView()
                        
                    case .tree:
                        
                        TreeView(tree: $document.model.tree)
                    }
                }
                .padding()
            }
            .toolbar {
                
                ToolView(tool: $document.model.tool)
            }
            .frame(minWidth: 280, maxWidth: 280)
        }
    }
}
