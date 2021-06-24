//
//  ChestnutTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct ChestnutTreeView: View {
    
    @Binding var tree: ChestnutTree
    
    var body: some View {
        
        GroupBox(label: Label("Chestnut", systemImage: "leaf")
                    .font(.headline)) {
        
            Text("ChestnutTreeView")
        }
    }
}

struct ChestnutTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ChestnutTreeView(tree: .constant(.default))
    }
}
