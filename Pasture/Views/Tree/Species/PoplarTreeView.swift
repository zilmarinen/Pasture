//
//  PoplarTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct PoplarTreeView: View {
    
    @Binding var tree: PoplarTree
    
    var body: some View {
        
        GroupBox(label: Label("Poplar", systemImage: "leaf")
                    .font(.headline)) {
        
            Text("PoplarTreeView")
        }
    }
}

struct PoplarTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PoplarTreeView(tree: .constant(.default))
    }
}
