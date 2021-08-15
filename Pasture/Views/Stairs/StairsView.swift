//
//  StairsView.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import SwiftUI
import Meadow

struct StairsView: View {
    
    @Binding var stairs: Stairs
    
    var body: some View {
        
        GroupBox(label: Label("Style", systemImage: "slider.horizontal.3")
                    .font(.headline)) {
            
            Form {
            
                Picker("Style", selection: $stairs.style) {
            
                    ForEach(StairType.allCases) { item in
            
                        Text(item.id.capitalized).tag(item)
                    }
                }
            }
        }
    }
}

struct StairsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        StairsView(stairs: .constant(.default))
    }
}

