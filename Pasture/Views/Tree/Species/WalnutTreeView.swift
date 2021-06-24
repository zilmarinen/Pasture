//
//  WalnutTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct WalnutTreeView: View {
    
    @Binding var tree: WalnutTree
    
    var body: some View {
        
        GroupBox(label: Label("Walnut", systemImage: "leaf")
                    .font(.headline)) {
        
            Text("WalnutTreeView")
        }
    }
}

struct WalnutTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        WalnutTreeView(tree: .constant(.default))
    }
}
