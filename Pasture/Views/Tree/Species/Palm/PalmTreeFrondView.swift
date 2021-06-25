//
//  PalmTreeFrondView.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import SwiftUI

struct PalmTreeFrondView: View {
    
    @Binding var frond: PalmTreeFrond
    
    var body: some View {
        
        Form {
            
            HStack {

                Stepper("Segments", value: $frond.segments, in: 3...10)
                TextField("Segments", value: $frond.segments, formatter: PastureDocument.Constants.Formatters.integer)
            }
            
            HStack {

                Stepper("Width", value: $frond.width, in: 0.1...1, step: 0.01)
                TextField("Width", value: $frond.width, formatter: PastureDocument.Constants.Formatters.double)
            }
            
            HStack {

                Stepper("Thickness", value: $frond.thickness, in: 0.1...1, step: 0.01)
                TextField("Thickness", value: $frond.thickness, formatter: PastureDocument.Constants.Formatters.double)
            }
            
            HStack {

                Stepper("Radius", value: $frond.radius, in: 0.1...1, step: 0.01)
                TextField("Radius", value: $frond.radius, formatter: PastureDocument.Constants.Formatters.double)
            }

            HStack {

                Stepper("Spread", value: $frond.spread, in: 0...1, step: 0.01)
                TextField("Spread", value: $frond.spread, formatter: PastureDocument.Constants.Formatters.double)
            }
        }
    }
}

struct PalmTreeFrondView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PalmTreeFrondView(frond: .constant(.default))
    }
}
