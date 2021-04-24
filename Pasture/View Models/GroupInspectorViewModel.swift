//
//  GroupInspectorViewModel.swift
//  Pasture
//
//  Created by Zack Brown on 22/04/2021.
//

import Euclid
import Foundation
import Meadow

extension GroupInspectorCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: GroupNode, polygonIndex: Int, vertexIndex: Int)
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class GroupInspectorViewModel: StateObserver<ViewState> {
        
    }
}
