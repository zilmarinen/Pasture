//
//  PineTreeView.swift
//
//  Created by Zack Brown on 12/06/2021.
//

import SwiftUI

struct PineTreeView: View {
    
    @Binding var tree: PineTree
    
    var body: some View {
        
        GroupBox(label: Label("Pine", systemImage: "leaf")
                    .font(.headline)) {
            
            Text("PineTreeView")
        
//            Form {
//
//                HStack {
//
//                    Stepper("Height", value: $foliage.height, in: 0.1...2, step: 0.1)
//                    TextField("Height", value: $foliage.height, formatter: Constants.Formatters.double)
//                }
//
//                HStack {
//
//                    Stepper("Segments", value: $foliage.segments, in: 3...10)
//                    TextField("Segments", value: $foliage.segments, formatter: Constants.Formatters.integer)
//                }
//
//                HStack {
//
//                    Stepper("Slices", value: $foliage.slices, in: 1...10)
//                    TextField("Slices", value: $foliage.slices, formatter: Constants.Formatters.integer)
//                }
//
//                HStack {
//
//                    Stepper("Spread", value: $foliage.spread, in: 0...0.25, step: 0.01)
//                    TextField("Spread", value: $foliage.spread, formatter: Constants.Formatters.double)
//                }
//
//                HStack {
//
//                    Stepper("Radius", value: $foliage.radius, in: 0.1...1, step: 0.01)
//                    TextField("Radius", value: $foliage.radius, formatter: Constants.Formatters.double)
//                }
//            }
        }
    }
}

struct PineTreeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PineTreeView(tree: .constant(.default))
    }
}
