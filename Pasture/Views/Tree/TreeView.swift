//
//  TreeView.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import SwiftUI

struct TreeView: View {
    
    @Binding var tree: Tree
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            GroupBox {
            
            TreeSpeciesView(size: $tree.size, species: $tree.species)
            
            switch tree.species {
                
            case .beech: BeechTreeView(tree: $tree.beech)
            case .chestnut: ChestnutTreeView(tree: $tree.chestnut)
            case .oak: OakTreeView(tree: $tree.oak)
            case .palm: PalmTreeView(tree: $tree.palm)
            case .pine: PineTreeView(tree: $tree.pine)
            case .poplar: PoplarTreeView(tree: $tree.poplar)
            case .walnut: WalnutTreeView(tree: $tree.walnut)
            }
                
            }
        }
        .controlSize(.small)
    }
}

struct TreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TreeView(tree: .constant(.default))
    }
}
