//
//  TrunkView.swift
//
//  Created by Zack Brown on 01/07/2021.
//

import SwiftUI

struct TrunkView: View {
    
    @Binding var trunk: Trunk
    
    var body: some View {
        
        Form {
            
            HStack {

                Stepper("Segments", value: $trunk.segments, in: 3...10)
                TextField("Segments", value: $trunk.segments, formatter: PastureDocument.Constants.Formatters.integer)
            }

            HStack {

                Stepper("Peak Radius", value: $trunk.peakRadius, in: 0.01...1, step: 0.01)
                TextField("Peak Radius", value: $trunk.peakRadius, formatter: PastureDocument.Constants.Formatters.double)
            }

            HStack {

                Stepper("Base Radius", value: $trunk.baseRadius, in: 0.01...1, step: 0.01)
                TextField("Base Radius", value: $trunk.baseRadius, formatter: PastureDocument.Constants.Formatters.double)
            }
            
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
    }
}

struct TrunkView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TrunkView(trunk: .constant(.default))
    }
}
