//
//  ToolView.swift
//
//  Created by Zack Brown on 15/10/2021.
//

import SwiftUI

struct ToolView: View {
    
    @ObservedObject var model: EditorViewModel

    var body: some View {
        
        ScrollView {

            VStack {
                    
                PrototypeToolView(title: model.prototype.species.id.capitalized, prototype: $model.prototype)

                Spacer()
            }
            .padding()
        }
        .frame(minWidth: PastureApp.Constants.toolWidth, idealWidth: PastureApp.Constants.toolWidth, maxWidth: PastureApp.Constants.toolWidth)
    }
}
