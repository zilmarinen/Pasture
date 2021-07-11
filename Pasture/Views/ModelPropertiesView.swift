//
//  ModelPropertiesView.swift
//
//  Created by Zack Brown on 30/06/2021.
//

import SwiftUI

struct ModelPropertiesView: View {
    
    @Binding var model: Model
    
    var body: some View {
        
        GroupBox(label: Label("Model Properties", systemImage: "info")
                    .font(.headline)) {
            
            Form {
                
                HStack {

                    Text("Name")
                    TextField("Name", text: $model.name)
                }
            }
        }
    }
}

struct ModelPropertiesView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ModelPropertiesView(model: .constant(.default))
    }
}
