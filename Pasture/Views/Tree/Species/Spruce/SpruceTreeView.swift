//
//  SpruceTreeView.swift
//  SpruceTreeView
//
//  Created by Zack Brown on 02/08/2021.
//

import SwiftUI

struct SpruceTreeView: View {
    
    @Binding var tree: SpruceTree
    
    var body: some View {
        
        SpruceTreeFoliageView(foliage: $tree.foliage)
        TreeTrunkView(trunk: $tree.trunk)
    }
}

struct SpruceTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SpruceTreeView(tree: .constant(.default))
    }
}
