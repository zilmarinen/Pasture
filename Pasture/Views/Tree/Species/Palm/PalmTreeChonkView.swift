//
//  PalmTreeChonkView.swift
//
//  Created by Zack Brown on 17/06/2021.
//

import SwiftUI

struct PalmTreeChonkView: View {
    
    @Binding var segment: PalmTreeChonk
    
    var body: some View {
        
        Form {
            
            HStack {

                Stepper("Segments", value: $segment.segments, in: 3...10)
                TextField("Segments", value: $segment.segments, formatter: PastureDocument.Constants.Formatters.integer)
            }

            HStack {

                Stepper("Peak Radius", value: $segment.peakRadius, in: 0.01...1, step: 0.01)
                TextField("Peak Radius", value: $segment.peakRadius, formatter: PastureDocument.Constants.Formatters.double)
            }

            HStack {

                Stepper("Base Radius", value: $segment.baseRadius, in: 0.01...1, step: 0.01)
                TextField("Base Radius", value: $segment.baseRadius, formatter: PastureDocument.Constants.Formatters.double)
            }
            
            HStack {

                Stepper("Peak", value: $segment.peak, in: 0.01...1, step: 0.01)
                TextField("Peak", value: $segment.peak, formatter: PastureDocument.Constants.Formatters.double)
            }

            HStack {

                Stepper("Base", value: $segment.base, in: 0.01...1, step: 0.01)
                TextField("Base", value: $segment.base, formatter: PastureDocument.Constants.Formatters.double)
            }
        }
    }
}

struct PalmTreeChonkView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PalmTreeChonkView(segment: .constant(.segment))
    }
}
