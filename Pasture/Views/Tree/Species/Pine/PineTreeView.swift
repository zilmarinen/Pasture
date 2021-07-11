//
//  PineTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct PineTreeView: View {
    
    @Binding var tree: PineTree
    
    var body: some View {
        
        PineTreeFoliageView(foliage: $tree.foliage)
        TreeTrunkView(trunk: $tree.trunk)
    }
}

struct PineTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PineTreeView(tree: .constant(.default))
    }
}
