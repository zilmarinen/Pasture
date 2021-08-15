//
//  StairType.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Meadow

extension StairType {
    
    var footprint: Footprint {
        
        switch self {
            
        case .sloped_1x1, .steep_1x1: return Footprint(coordinate: .zero, nodes: [.zero])
        case .sloped_2x1, .steep_2x1: return Footprint(coordinate: .zero, nodes: [.zero, .right])
        case .sloped_1x2, .steep_1x2: return Footprint(coordinate: .zero, nodes: [.zero, .forward])
        case .sloped_2x2, .steep_2x2: return Footprint(coordinate: .zero, nodes: [.zero, .right, .forward, .right + .forward])
        }
    }
    
    var steep: Bool {
        
        switch self {
            
        case .steep_1x1,
                .steep_1x2,
                .steep_2x1,
                .steep_2x2: return true
            
        default: return false
        }
    }
}
