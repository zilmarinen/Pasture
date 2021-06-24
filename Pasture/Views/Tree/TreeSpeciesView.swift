//
//  TreeSpeciesView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct TreeSpeciesView: View {
    
    @Binding var size: Tree.Size
    @Binding var species: Tree.Species
    
    var body: some View {
        
        GroupBox(label: Label("Tree Type", systemImage: "slider.horizontal.3")
                    .font(.headline)) {
            
            Form {
            
                Picker("Species", selection: $species) {
            
                    ForEach(Tree.Species.allCases) { item in
            
                        Text(item.id).tag(item)
                    }
                }
                
                Picker("Size", selection: $size) {
            
                    ForEach(Tree.Size.allCases) { item in
            
                        Text(item.rawValue.capitalized).tag(item)
                    }
                }
            }
        }
    }
}

struct TreeSpeciesView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TreeSpeciesView(size: .constant(.small),
                        species: .constant(.beech(.default)))
    }
}
