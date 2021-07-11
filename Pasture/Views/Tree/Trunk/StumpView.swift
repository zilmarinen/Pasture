//
//  StumpView.swift
//
//  Created by Zack Brown on 01/07/2021.
//

import SwiftUI

struct StumpView: View {
    
    @Binding var stump: Stump
    
    var body: some View {
        
        Form {
            
            HStack {

                Stepper("Segments", value: $stump.segments, in: 3...10)
                TextField("Segments", value: $stump.segments, formatter: PastureDocument.Constants.Formatters.integer)
            }

            HStack {

                Stepper("Inner Radius", value: $stump.innerRadius, in: 0.01...1, step: 0.01)
                TextField("Inner Radius", value: $stump.innerRadius, formatter: PastureDocument.Constants.Formatters.double)
            }

            HStack {

                Stepper("Outer Radius", value: $stump.outerRadius, in: 0.01...1, step: 0.01)
                TextField("Outer Radius", value: $stump.outerRadius, formatter: PastureDocument.Constants.Formatters.double)
            }
            
            HStack {

                Stepper("Peak", value: $stump.peak, in: 0.01...1, step: 0.01)
                TextField("Peak", value: $stump.peak, formatter: PastureDocument.Constants.Formatters.double)
            }

            HStack {

                Stepper("Base", value: $stump.base, in: 0.01...1, step: 0.01)
                TextField("Base", value: $stump.base, formatter: PastureDocument.Constants.Formatters.double)
            }
            
            HStack {

                Stepper("Legs", value: $stump.legs, in: 3...10)
                TextField("Legs", value: $stump.legs, formatter: PastureDocument.Constants.Formatters.integer)
            }
            
            HStack {

                Stepper("Spread", value: $stump.spread, in: 0.01...1, step: 0.01)
                TextField("Spread", value: $stump.spread, formatter: PastureDocument.Constants.Formatters.double)
            }
        }
    }
}

struct StumpView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        StumpView(stump: .constant(.default))
    }
}
