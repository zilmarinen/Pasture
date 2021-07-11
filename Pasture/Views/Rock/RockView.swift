//
//  RockView.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import SwiftUI

struct RockView: View {
    
    @Binding var rock: Rock
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            GroupBox {
            
                RockCategoryView(category: $rock.category)
                
                switch rock.category {
                    
                case .causeway: CausewayView(rock: $rock.causeway)
                }
//            TreeSpeciesView(size: $tree.size, species: $tree.species)
//
//            switch tree.species {
//
//            case .beech: BeechTreeView(tree: $tree.beech)
//            case .chestnut: ChestnutTreeView(tree: $tree.chestnut)
//            case .oak: OakTreeView(tree: $tree.oak)
//            case .palm: PalmTreeView(tree: $tree.palm)
//            case .pine: PineTreeView(tree: $tree.pine)
//            case .poplar: PoplarTreeView(tree: $tree.poplar)
//            case .walnut: WalnutTreeView(tree: $tree.walnut)
//            }
                
            }
        }
    }
}

struct RockView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RockView(rock: .constant(.default))
    }
}
