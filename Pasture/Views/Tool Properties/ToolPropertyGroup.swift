//
//  ToolPropertyGroup.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import SwiftUI

struct ToolPropertyGroup<Content: View>: View {
    
    let model: ToolPropertyGroupModel?
    let content: Content

    init(model: ToolPropertyGroupModel? = nil, @ViewBuilder content: () -> Content) {
        
        self.model = model
        self.content = content()
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {

                if let imageName = model?.imageName {
                    
                    Image(systemName: imageName)
                        .foregroundColor(.primary)
                }

                if let title = model?.title {
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            
                if let badge = model?.badge {
                    
                    Spacer()
                    
                    BadgeView(model: badge)
                }
            }
            
            VStack {
            
                content
            }
            .controlSize(.small)
            .labelsHidden()
            .padding(PastureApp.Constants.padding)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(PastureApp.Constants.cornerRadius)
        }
    }
}
