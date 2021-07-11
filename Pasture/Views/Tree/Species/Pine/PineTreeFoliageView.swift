//
//  PineTreeFoliageView.swift
//  Pasture
//
//  Created by Zack Brown on 08/07/2021.
//

import SwiftUI

struct PineTreeFoliageView: View {
    
    @Binding var foliage: PineTreeFoliage
    
    var body: some View {
        
        GroupBox(label: Label("Foliage", systemImage: "leaf").font(.headline)) {
            
            Form {
                
                Form {
                    
                    HStack {

                        Stepper("Height", value: $foliage.height, in: 0.1...3, step: 0.1)
                        TextField("Height", value: $foliage.height, formatter: PastureDocument.Constants.Formatters.double)
                    }
                    
                    HStack {

                        Stepper("Slices", value: $foliage.slices, in: 1...10)
                        TextField("Slices", value: $foliage.slices, formatter: PastureDocument.Constants.Formatters.integer)
                    }
                    
                    HStack {

                        Stepper("Segments", value: $foliage.segments, in: 3...10)
                        TextField("Segments", value: $foliage.segments, formatter: PastureDocument.Constants.Formatters.integer)
                    }

                    HStack {

                        Stepper("Peak Radius", value: $foliage.peakRadius, in: 0.01...1, step: 0.01)
                        TextField("Peak Radius", value: $foliage.peakRadius, formatter: PastureDocument.Constants.Formatters.double)
                    }

                    HStack {

                        Stepper("Base Radius", value: $foliage.baseRadius, in: 0.01...1, step: 0.01)
                        TextField("Base Radius", value: $foliage.baseRadius, formatter: PastureDocument.Constants.Formatters.double)
                    }
                    
                    HStack {

                        Stepper("Flop", value: $foliage.flop, in: 0.01...1, step: 0.01)
                        TextField("Flop", value: $foliage.flop, formatter: PastureDocument.Constants.Formatters.double)
                    }
                }
            }
        }
    }
}

struct PineTreeFoliageView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PineTreeFoliageView(foliage: .constant(.default))
    }
}
