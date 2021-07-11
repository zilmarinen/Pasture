//
//  CausewayView.swift
//
//  Created by Zack Brown on 28/06/2021.
//

import SwiftUI

struct CausewayView: View {
    
    @Binding var rock: Causeway
    
    var body: some View {
        
        NoiseView(noise: $rock.noise)
        
        GroupBox(label: Label("Causeway", systemImage: "leaf").font(.headline)) {
            
            Form {
                
                Picker("Shape", selection: $rock.shape) {
            
                    ForEach(Causeway.Shape.allCases) { item in
            
                        Text(item.id.capitalized).tag(item)
                    }
                }
                
                Picker("Pentomino", selection: $rock.pentomino) {
            
                    ForEach(Pentomino.allCases) { item in
            
                        Text(item.id.capitalized).tag(item)
                    }
                }
                
                HStack {

                    Stepper("Radius", value: $rock.radius, in: 0.01...1, step: 0.01)
                    TextField("Radius", value: $rock.radius, formatter: PastureDocument.Constants.Formatters.double)
                }
                
                HStack {
                    
                    Stepper("Margin", value: $rock.margin, in: 0...1, step: 0.01)
                    TextField("Margin", value: $rock.margin, formatter: PastureDocument.Constants.Formatters.double)
                }
                
                HStack {

                    Stepper("Peak", value: $rock.peak, in: rock.base...1, step: 0.01)
                    TextField("Peak", value: $rock.peak, formatter: PastureDocument.Constants.Formatters.double)
                }

                HStack {

                    Stepper("Base", value: $rock.base, in: 0.01...rock.peak, step: 0.01)
                    TextField("Base", value: $rock.base, formatter: PastureDocument.Constants.Formatters.double)
                }
            }
        }
    }
}

struct CausewayView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CausewayView(rock: .constant(.default))
    }
}
