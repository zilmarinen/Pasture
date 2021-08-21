//
//  BridgeView.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import SwiftUI
import Meadow

struct BridgeView: View {
    
    @Binding var bridge: Bridge
    
    var body: some View {
        
        GroupBox(label: Label("Style", systemImage: "slider.horizontal.3")
                    .font(.headline)) {
            
            Form {
            
                Picker("Style", selection: $bridge.material) {
            
                    ForEach(BridgeMaterial.allCases) { item in
            
                        Text(item.id.capitalized).tag(item)
                    }
                }
            }
        }
    }
}

struct BridgeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BridgeView(bridge: .constant(.default))
    }
}


