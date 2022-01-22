//
//  Species.swift
//
//  Created by Zack Brown on 18/10/2021.
//

import Harvest

enum Species: String, CaseIterable, Identifiable {
    
    case bamboo
    case cherryBlossom
    case gingko
    case hebe
    
    var id: String {
        
        switch self {
            
        case .bamboo: return "bamboo"
        case .cherryBlossom: return "cherry blossom"
        case .gingko: return "gingko"
        case .hebe: return "hebe"
        }
    }
    
    var colorPalette: ColorPalette {
        
        switch self {
            
        case .bamboo: return .bamboo
        case .cherryBlossom: return .cherryBlossom
        case .gingko: return .gingko
        case .hebe: return .hebe
        }
    }
}
