//
//  BuildingView.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import SwiftUI

struct BuildingView: View {
    
    @Binding var building: Building
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            GroupBox {
                
                BuildingArchitectureView(building: $building)
                BuildingRoofView(roof: $building.roof)
            }
        }
    }
}

struct BuildingView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BuildingView(building: .constant(.default))
    }
}
