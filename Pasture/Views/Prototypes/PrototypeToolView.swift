//
//  PrototypeToolView.swift
//
//  Created by Zack Brown on 28/10/2021.
//

import Harvest
import Meadow
import SwiftUI

struct PrototypeToolView: View {
    
    let title: String
    
    @Binding var prototype: EditorFoliage

    var body: some View {
        
        ToolPropertySection {

            ToolPropertyGroup(model: .init(title: "Foliage", imageName: "square.grid.3x3")) {
                
                ToolPropertyView(title: "Foliage", color: .pink) {

                    Picker("Species", selection: $prototype.species) {

                        ForEach(Species.allCases, id: \.self) { species in

                            Text(species.id.capitalized).tag(species)
                        }
                    }
                }
                
                ToolPropertyView(title: "Size", color: .pink) {
                    
                    Picker("Footprint", selection: $prototype.footprint) {

                        ForEach(Wireframe.Footprint.allCases, id: \.self) { tile in

                            Text(tile.id.capitalized).tag(tile)
                        }
                    }
                }
            }
        }
    }
}
