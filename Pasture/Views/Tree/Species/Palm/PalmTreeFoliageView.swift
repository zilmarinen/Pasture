//
//  PalmTreeFoliageView.swift
//
//  Created by Zack Brown on 21/06/2021.
//

import SwiftUI

struct PalmTreeFoliageView: View {
    
    @Binding var foliage: PalmTreeFoliage
    
    var body: some View {
        
        GroupBox(label: Label("Foliage", systemImage: "leaf").font(.headline)) {
            
            Form {
                
                HStack {

                    Stepper("Fronds", value: $foliage.fronds, in: 3...10)
                    TextField("Fronds", value: $foliage.fronds, formatter: PastureDocument.Constants.Formatters.integer)
                }
            }
            
            GroupBox(label: Label("Crown", systemImage: "crown").font(.headline)) {
                
                PalmTreeChonkView(segment: $foliage.crown)
            }
            
            GroupBox(label: Label("Fronds", systemImage: "leaf").font(.headline)) {
                
                PalmTreeFrondView(frond: $foliage.frond)
            }
        }
    }
}

struct PalmTreeFoliageView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PalmTreeFoliageView(foliage: .constant(.default))
    }
}
