//
//  ChestnutTree.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import Euclid
import Foundation
import Meadow
import SwiftUI

class ChestnutTree: Codable, Hashable, ObservableObject {
    
    static let `default`: ChestnutTree = ChestnutTree(trunk: .default,
                                                      noise: .default)
    
    enum CodingKeys: CodingKey {
        
        case trunk
        case noise
    }
    
    @Published var trunk: TreeTrunk
    @Published var noise: Noise
    
    init(trunk: TreeTrunk,
         noise: Noise) {
        
        self.trunk = trunk
        self.noise = noise
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        trunk = try container.decode(TreeTrunk.self, forKey: .trunk)
        noise = try container.decode(Noise.self, forKey: .noise)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(trunk, forKey: .trunk)
        try container.encode(noise, forKey: .noise)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(trunk)
        hasher.combine(noise)
    }
    
    static func == (lhs: ChestnutTree, rhs: ChestnutTree) -> Bool {
        
        return  lhs.trunk == rhs.trunk &&
                lhs.noise == rhs.noise
    }
}

extension ChestnutTree: Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        return []
    }
}
