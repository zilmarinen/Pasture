//
//  Tree.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import Euclid
import Foundation
import SwiftUI
import Meadow

class Tree: Codable, Hashable, ObservableObject {
    
    static let `default`: Tree = Tree(species: .beech(.default))
    
    enum CodingKeys: CodingKey {
        
        case size
        case species
    }
     
    enum Size: String, CaseIterable, Codable, Hashable, Identifiable {
        
        case small
        case medium
        case large
        
        var id: String { self.rawValue }
    }
    
    enum Species: CaseIterable, Codable, Hashable, Identifiable {
        
        static var allCases: [Tree.Species] { [.beech(.default),
                                               .chestnut(.default),
                                               .oak(.default),
                                               .palm(.default),
                                               .pine(.default),
                                               .poplar(.default),
                                               .walnut(.default)] }
        
        case beech(BeechTree)
        case chestnut(ChestnutTree)
        case oak(OakTree)
        case palm(PalmTree)
        case pine(PineTree)
        case poplar(PoplarTree)
        case walnut(WalnutTree)
        
        var id: String {
            
            switch self {

            case .beech: return "Beech"
            case .chestnut: return "Chestnut"
            case .oak: return "Oak"
            case .palm: return "Palm"
            case .pine: return "Pine"
            case .poplar: return "Poplar"
            case .walnut: return "Walnut"
            }
        }
        
        var texture: Texture? {
            
            guard let image = MDWImage.asset(named: id.lowercased() + "_tree", in: .main) else { return nil }
            
            return Texture(key: "foliage", image: image)
        }
    }
    
    var footprint: Footprint {
        
        switch size {
            
        case .small: return Footprint(coordinate: .zero, nodes: [.zero])
        case .medium: return Footprint(coordinate: .zero, nodes: [.zero])
        case .large: return Footprint(coordinate: .zero, nodes: [.zero])
        }
    }
    
    @Published var size: Size = .small
    @Published var species: Species = .beech(.default)
    
    init(species: Species) {
        
        self.species = species
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        size = try container.decode(Tree.Size.self, forKey: .size)
        species = try container.decode(Species.self, forKey: .species)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(size, forKey: .size)
        try container.encode(species, forKey: .species)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(species)
        hasher.combine(size.rawValue)
    }
    
    static func == (lhs: Tree, rhs: Tree) -> Bool {
        
        return  lhs.species == rhs.species &&
                lhs.size == rhs.size
    }
}

extension Tree {
    
    var beech: BeechTree {
        
        get {
            
            switch self.species {
                
            case .beech(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.species = .beech(newValue)
        }
    }
    
    var chestnut: ChestnutTree {
        
        get {
            
            switch self.species {
                
            case .chestnut(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.species = .chestnut(newValue)
        }
    }
    
    var oak: OakTree {
        
        get {
            
            switch self.species {
                
            case .oak(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.species = .oak(newValue)
        }
    }
    
    var palm: PalmTree {
        
        get {
            
            switch self.species {
                
            case .palm(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.species = .palm(newValue)
        }
    }
    
    var pine: PineTree {
        
        get {
            
            switch self.species {
                
            case .pine(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.species = .pine(newValue)
        }
    }
    
    var poplar: PoplarTree {
        
        get {
            
            switch self.species {
                
            case .poplar(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.species = .poplar(newValue)
        }
    }
    
    var walnut: WalnutTree {
        
        get {
            
            switch self.species {
                
            case .walnut(let tree): return tree
                
            default: return .default
            }
        }
        set {
            
            self.species = .walnut(newValue)
        }
    }
}

extension Tree: Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        switch species {
            
        case .beech(let tree): return tree.build(position: position)
        case .chestnut(let tree): return tree.build(position: position)
        case .oak(let tree): return tree.build(position: position)
        case .palm(let tree): return tree.build(position: position)
        case .pine(let tree): return tree.build(position: position)
        case .poplar(let tree): return tree.build(position: position)
        case .walnut(let tree): return tree.build(position: position)
        }
    }
}
