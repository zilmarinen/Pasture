//
//  WallView.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import SwiftUI
import Meadow

struct WallView: View {
    
    @Binding var walls: Walls
    
    var body: some View {
        
        GroupBox(label: Label("Style", systemImage: "slider.horizontal.3")
                    .font(.headline)) {
            
            Form {
            
                Picker("Style", selection: $walls.style) {
            
                    ForEach(WallTileMaterial.allCases) { item in
            
                        Text(item.id.capitalized).tag(item)
                    }
                }
            }
        }
    }
}

struct WallView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        WallView(walls: .constant(.default))
    }
}
