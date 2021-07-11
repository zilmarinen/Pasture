//
//  PalmTreeTrunkView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct PalmTreeTrunkView: View {
    
    @Binding var trunk: PalmTreeTrunk
    
    var body: some View {
        
        GroupBox(label: Label("Trunk", systemImage: "pyramid").font(.headline)) {
        
            Form {
                
                HStack {

                    Stepper("Height", value: $trunk.height, in: 0.1...2, step: 0.1)
                    TextField("Height", value: $trunk.height, formatter: PastureDocument.Constants.Formatters.double)
                }
                
                HStack {

                    Stepper("Slices", value: $trunk.slices, in: 1...10)
                    TextField("Slices", value: $trunk.slices, formatter: PastureDocument.Constants.Formatters.integer)
                }
                
                HStack {

                    Stepper("Spread", value: $trunk.spread, in: 0...0.25, step: 0.01)
                    TextField("Spread", value: $trunk.spread, formatter: PastureDocument.Constants.Formatters.double)
                }
            }
                
            GroupBox(label: Label("Segments", systemImage: "rhombus").font(.headline)) {
                
                PalmTreeChonkView(segment: $trunk.segment)
            }
                
            GroupBox(label: Label("Throne", systemImage: "triangle").font(.headline)) {
                    
                PalmTreeChonkView(segment: $trunk.throne)
            }
        }
    }
}

struct PalmTreeTrunkView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PalmTreeTrunkView(trunk: .constant(.default))
    }
}
