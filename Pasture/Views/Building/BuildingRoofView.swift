//
//  BuildingRoofView.swift
//  BuildingRoofView
//
//  Created by Zack Brown on 26/07/2021.
//

import Meadow
import SwiftUI

struct BuildingRoofView: View {
    
    @Binding var roof: BuildingRoof.Style
    
    var body: some View {
        
        GroupBox(label: Label("Roof", systemImage: "building").font(.headline)) {
            
            Form {
                
                Picker("Style", selection: $roof) {
            
                    ForEach(BuildingRoof.Style.allCases) { item in
            
                        Text(item.id).tag(item)
                    }
                }
                
                switch roof {
                    
                case .flat: EmptyView()
                    
                default:
                    
                    Picker("Direction", selection: $roof.direction) {
                
                        ForEach(Cardinal.allCases) { item in
                
                            Text(item.id).tag(item)
                        }
                    }
                    
                    switch roof {
                        
                    case .saltbox:
                        
                        Picker("Peak", selection: $roof.peak) {
                    
                            ForEach(SaltboxRoof.Peak.allCases) { item in
                    
                                Text(item.id).tag(item)
                            }
                        }
                        
                    default: EmptyView()
                    }
                }
            }
        }
    }
}

struct BuildingRoofView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BuildingRoofView(roof: .constant(.saltbox(direction: .north, peak: .left)))
    }
}
