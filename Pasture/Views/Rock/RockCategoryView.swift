//
//  RockCategoryView.swift
//
//  Created by Zack Brown on 28/06/2021.
//

import SwiftUI

struct RockCategoryView: View {
    
    @Binding var category: Rock.Category
    
    var body: some View {
        
        GroupBox(label: Label("Rock Type", systemImage: "square")
                    .font(.headline)) {
            
            Form {
            
                Picker("Category", selection: $category) {
            
                    ForEach(Rock.Category.allCases) { item in
            
                        Text(item.id).tag(item)
                    }
                }
            }
        }
    }
}

struct RockCategoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RockCategoryView(category: .constant(.causeway(.default)))
    }
}
