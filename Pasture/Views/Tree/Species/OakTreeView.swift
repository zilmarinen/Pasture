//
//  OakTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct OakTreeView: View {
    
    @Binding var tree: OakTree
    
    var body: some View {
        
        GroupBox(label: Label("Oak", systemImage: "leaf")
                    .font(.headline)) {
        
            Text("OakTreeView")
        }
    }
}

struct OakTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        OakTreeView(tree: .constant(.default))
    }
}
