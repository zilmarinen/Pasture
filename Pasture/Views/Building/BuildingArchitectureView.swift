//
//  BuildingArchitectureView.swift
//
//  Created by Zack Brown on 16/07/2021.
//

import SwiftUI

struct BuildingArchitectureView: View {
    
    @Binding var building: Building
    
    var body: some View {
        
        GroupBox(label: Label("Architecture", systemImage: "building")
                    .font(.headline)) {
            
            Form {
                
                Picker("Style", selection: $building.architecture) {
            
                    ForEach(Building.Architecture.allCases) { item in
            
                        Text(item.id).tag(item)
                    }
                }
                
                Picker("Zachomino", selection: $building.zachomino) {
            
                    ForEach(Zachomino.allCases) { item in
            
                        Text(item.id.uppercased()).tag(item)
                    }
                }
                
                HStack {

                    Stepper("Layers", value: $building.layers, in: 1...2)
                    TextField("Layers", value: $building.layers, formatter: PastureDocument.Constants.Formatters.integer)
                }
            }
        }
    }
}

struct BuildingArchitectureView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BuildingArchitectureView(building: .constant(.default))
    }
}
