//
//  SpruceTreeFoliageView.swift
//
//  Created by Zack Brown on 02/08/2021.
//

import SwiftUI

struct SpruceTreeFoliageView: View {
    
    @Binding var foliage: SpruceTreeFoliage
    
    var body: some View {
        
        GroupBox(label: Label("Foliage", systemImage: "leaf").font(.headline)) {
            
            Form {
                
                Form {
                    
                    HStack {

                        Stepper("Height", value: $foliage.height, in: 0.1...3, step: 0.1)
                        TextField("Height", value: $foliage.height, formatter: PastureDocument.Constants.Formatters.double)
                    }
                    
                    HStack {

                        Stepper("Turns", value: $foliage.turns, in: 1...10)
                        TextField("Turns", value: $foliage.turns, formatter: PastureDocument.Constants.Formatters.integer)
                    }
                    
                    HStack {

                        Stepper("Segments", value: $foliage.segments, in: 3...10)
                        TextField("Segments", value: $foliage.segments, formatter: PastureDocument.Constants.Formatters.integer)
                    }

                    HStack {

                        Stepper("Radius", value: $foliage.radius, in: 0.01...1, step: 0.01)
                        TextField("Radius", value: $foliage.radius, formatter: PastureDocument.Constants.Formatters.double)
                    }
                    
                    HStack {

                        Stepper("Thickness", value: $foliage.thickness, in: 0.01...0.1, step: 0.01)
                        TextField("Thickness", value: $foliage.thickness, formatter: PastureDocument.Constants.Formatters.double)
                    }
                }
            }
        }
    }
}

struct SpruceTreeFoliageView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SpruceTreeFoliageView(foliage: .constant(.default))
    }
}
