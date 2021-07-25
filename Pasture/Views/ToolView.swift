//
//  ToolView.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import SwiftUI
import SceneKit
struct ToolView: View {
    
    @Binding var tool: Model.Tool
    
    var body: some View {
        
        Picker("Tool Type", selection: $tool) {
    
            ForEach(Model.Tool.allCases) { item in
    
                Label(item.id, systemImage: item.imageName).tag(item)
            }
        }
    }
}

struct ToolView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ToolView(tool: .constant(.building(.default)))
    }
}
