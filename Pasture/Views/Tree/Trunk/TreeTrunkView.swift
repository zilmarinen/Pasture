//
//  TreeTrunkView.swift
//
//  Created by Zack Brown on 01/07/2021.
//

import SwiftUI

struct TreeTrunkView: View {
    
    @Binding var trunk: TreeTrunk
    
    var body: some View {
        
        GroupBox(label: Label("Trunk", systemImage: "pyramid").font(.headline)) {
            
            GroupBox(label: Label("Segments", systemImage: "rhombus").font(.headline)) {
                
                TrunkView(trunk: $trunk.trunk)
            }
                
            GroupBox(label: Label("Stump", systemImage: "triangle").font(.headline)) {
                
                StumpView(stump: $trunk.stump)
            }
        }
    }
}

struct TreeTrunkView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TreeTrunkView(trunk: .constant(.default))
    }
}
