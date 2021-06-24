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
    
    enum CodingKeys: CodingKey {
        
        case segments
        case slices
        case spread
        case radius
        case height
    }
    
    static let `default`: ChestnutTree = ChestnutTree()
    
    @Published var segments: Int
    @Published var slices: Int
    @Published var spread: Double
    @Published var radius: Double
    @Published var height: Double
    
    init(segments: Int = 7,
         slices: Int = 7,
         spread: Double = 0.05,
         radius: Double = 0.49,
         height: Double = 1.3) {
        
        self.segments = segments
        self.slices = slices
        self.spread = spread
        self.radius = radius
        self.height = height
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segments = try container.decode(Int.self, forKey: .segments)
        slices = try container.decode(Int.self, forKey: .slices)
        spread = try container.decode(Double.self, forKey: .spread)
        radius = try container.decode(Double.self, forKey: .radius)
        height = try container.decode(Double.self, forKey: .height)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(segments, forKey: .segments)
        try container.encode(slices, forKey: .slices)
        try container.encode(spread, forKey: .spread)
        try container.encode(radius, forKey: .radius)
        try container.encode(height, forKey: .height)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(segments)
        hasher.combine(slices)
        hasher.combine(spread)
        hasher.combine(radius)
        hasher.combine(height)
    }
    
    static func == (lhs: ChestnutTree, rhs: ChestnutTree) -> Bool {
        
        return  lhs.segments == rhs.segments &&
                lhs.slices == rhs.slices &&
                lhs.spread == rhs.spread &&
                lhs.radius == rhs.radius &&
                lhs.height == rhs.height
    }
}

extension ChestnutTree: Prop {
    
    func build() -> [Euclid.Polygon] {
        
        return []
    }
}
