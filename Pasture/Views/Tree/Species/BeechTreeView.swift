//
//  BeechTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct BeechTreeView: View {
    
    @Binding var tree: BeechTree
    
    var body: some View {
        
        GroupBox(label: Label("Beech", systemImage: "leaf")
                    .font(.headline)) {
        
            Text("BeechTreeView")
        }
    }
}

struct BeechTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BeechTreeView(tree: .constant(.default))
    }
}
