//
//  Model.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import Euclid
import Foundation
import SwiftUI

class Model: Codable, ObservableObject {
    
    static let `default`: Model = Model(name: "Model",
                                        tool: .tree(.default))
    
    enum CodingKeys: CodingKey {
        
        case name
        case tool
    }
    
    enum Tool: CaseIterable, Codable, Hashable, Identifiable {
        
        static var allCases: [Model.Tool] { [.building(.default),
                                             .bush,
                                             .rock(.default),
                                             .stairs(.default),
                                             .tree(.default),
                                             .walls(.default)]}
        
        case building(Building)
        case bush
        case rock(Rock)
        case stairs(Stairs)
        case tree(Tree)
        case walls(Walls)
        
        var id: String {
            
            switch self {
                
            case .building: return "Building"
            case .bush: return "Bush"
            case .rock: return "Rock"
            case .stairs: return "Stairs"
            case .tree: return "Tree"
            case .walls: return "Walls"
            }
        }
        
        var imageName: String {
            
            switch self {
                
            case .building: return "building"
            case .bush: return "leaf"
            case .rock: return "triangle"
            case .stairs: return "triangle"
            case .tree: return "cone"
            case .walls: return "building"
            }
        }
    }
    
    @Published var name: String
    @Published var tool: Tool = .tree(.default)
    
    init(name: String,
         tool: Tool) {
        
        self.name = name
        self.tool = tool
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
    
    var building: Building {
        
        get {
            
            switch self.tool {
                
            case .building(let model): return model
                
            default: return .default
            }
        }
        set {
            
            self.tool = .building(newValue)
        }
    }
    
    var rock: Rock {
        
        get {
            
            switch self.tool {
                
            case .rock(let model): return model
                
            default: return .default
            }
        }
        set {
            
            self.tool = .rock(newValue)
        }
    }
    
    var stairs: Stairs {
        
        get {
            
            switch self.tool {
                
            case .stairs(let model): return model
                
            default: return .default
            }
        }
        set {
            
            self.tool = .stairs(newValue)
        }
    }
    
    var tree: Tree {
        
        get {
            
            switch self.tool {
                
            case .tree(let model): return model
                
            default: return .default
            }
        }
        set {
            
            self.tool = .tree(newValue)
        }
    }
    
    var walls: Walls {
        
        get {
            
            switch self.tool {
                
            case .walls(let model): return model
                
            default: return .default
            }
        }
        set {
            
            self.tool = .walls(newValue)
        }
    }
}
