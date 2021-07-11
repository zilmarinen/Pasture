//
//  NoiseView.swift
//
//  Created by Zack Brown on 30/06/2021.
//

import SwiftUI

struct NoiseView: View {
    
    @Binding var noise: Noise
    
    var body: some View {
        
        GroupBox(label: Label("Noise", systemImage: "slider.horizontal.3").font(.headline)) {
            
            Form {
                
                HStack {

                    Stepper("Frequency", value: $noise.frequency, in: 1...16)
                    TextField("Frequency", value: $noise.frequency, formatter: PastureDocument.Constants.Formatters.integer)
                }
                
                HStack {

                    Stepper("Octaves", value: $noise.octaveCount, in: 1...16)
                    TextField("Octaves", value: $noise.octaveCount, formatter: PastureDocument.Constants.Formatters.integer)
                }
                
                HStack {

                    Stepper("Persistence", value: $noise.persistence, in: 0...1, step: 0.01)
                    TextField("Persistence", value: $noise.persistence, formatter: PastureDocument.Constants.Formatters.double)
                }
                
                HStack {

                    Stepper("Lacunarity", value: $noise.lacunarity, in: -10...10, step: 0.01)
                    TextField("Lacunarity", value: $noise.lacunarity, formatter: PastureDocument.Constants.Formatters.double)
                }
                
                HStack {

                    Text("Seed")
                    TextField("Seed", value: $noise.seed, formatter: PastureDocument.Constants.Formatters.integer)
                }
            }
        }
    }
}

struct NoiseView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NoiseView(noise: .constant(.default))
    }
}
