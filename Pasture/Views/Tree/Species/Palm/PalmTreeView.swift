//
//  PalmTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct PalmTreeView: View {
    
    @Binding var tree: PalmTree
    
    var body: some View {
        
        PalmTreeFoliageView(foliage: $tree.foliage)
        PalmTreeTrunkView(trunk: $tree.trunk)
    }
}

struct PalmTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PalmTreeView(tree: .constant(.default))
    }
}
