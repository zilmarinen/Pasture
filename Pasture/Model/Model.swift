//
//  Model.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import Euclid
import Foundation
import SwiftUI

class Model: Codable, ObservableObject {
    
    enum CodingKeys: CodingKey {
        
        case name
        case tool
    }
    
    enum Tool: CaseIterable, Codable, Hashable, Identifiable {
        
        static var allCases: [Model.Tool] { [.building,
                                             .bush,
                                             .rock,
                                             .tree(.default)]}
        
        case building
        case bush
        case rock
        case tree(Tree)
        
        var id: String {
            
            switch self {
                
            case .building: return "Building"
            case .bush: return "Bush"
            case .rock: return "Rock"
            case .tree: return "Tree"
            }
        }
        
        var imageName: String {
            
            switch self {
                
            case .building: return "building"
            case .bush: return "leaf"
            case .rock: return "triangle"
            case .tree: return "cone"
            }
        }
    }
    
    @Published var name: String
    @Published var tool: Tool = .tree(.default)
    
    init(name: String) {
        
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        tool = try container.decode(Tool.self, forKey: .tool)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(tool, forKey: .tool)
    }
}

extension Model {
    
    var tree: Tree {
        
        get {
            
            switch self.tool {
                
            case .tree(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.tool = .tree(newValue)
        }
    }
}
