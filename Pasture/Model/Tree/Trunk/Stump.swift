//
//  Stump.swift
//
//  Created by Zack Brown on 01/07/2021.
//

import SwiftUI

class Stump: Codable, Hashable, ObservableObject {
    
    static let `default`: Stump = Stump(innerRadius: 0.1,
                                        outerRadius: 0.4,
                                        peak: 0.2,
                                        base: 0.05,
                                        segments: 7,
                                        legs: 4,
                                        spread: 0.01)
    
    static let spruce: Stump = Stump(innerRadius: 0.1,
                                     outerRadius: 0.21,
                                     peak: 0.2,
                                     base: 0.05,
                                     segments: 7,
                                     legs: 7,
                                     spread: 0.01)
    
    enum CodingKeys: CodingKey {
        
        case innerRadius
        case outerRadius
        case peak
        case base
        case segments
        case legs
        case spread
    }
    
    @Published var innerRadius: Double
    @Published var outerRadius: Double
    @Published var peak: Double
    @Published var base: Double
    @Published var segments: Int
    @Published var legs: Int
    @Published var spread: Double
    
    init(innerRadius: Double,
         outerRadius: Double,
         peak: Double,
         base: Double,
         segments: Int,
         legs: Int,
         spread: Double) {
        
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.peak = peak
        self.base = base
        self.segments = segments
        self.legs = legs
        self.spread = spread
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        innerRadius = try container.decode(Double.self, forKey: .innerRadius)
        outerRadius = try container.decode(Double.self, forKey: .outerRadius)
        peak = try container.decode(Double.self, forKey: .peak)
        base = try container.decode(Double.self, forKey: .base)
        segments = try container.decode(Int.self, forKey: .segments)
        legs = try container.decode(Int.self, forKey: .legs)
        spread = try container.decode(Double.self, forKey: .spread)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(innerRadius, forKey: .innerRadius)
        try container.encode(outerRadius, forKey: .outerRadius)
        try container.encode(peak, forKey: .peak)
        try container.encode(base, forKey: .base)
        try container.encode(segments, forKey: .segments)
        try container.encode(legs, forKey: .legs)
        try container.encode(spread, forKey: .spread)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(innerRadius)
        hasher.combine(outerRadius)
        hasher.combine(peak)
        hasher.combine(base)
        hasher.combine(segments)
        hasher.combine(legs)
        hasher.combine(spread)
    }
    
    static func == (lhs: Stump, rhs: Stump) -> Bool {
        
        return  lhs.innerRadius == rhs.innerRadius &&
                lhs.outerRadius == rhs.outerRadius &&
                lhs.peak == rhs.peak &&
                lhs.base == rhs.base &&
                lhs.segments == rhs.segments &&
                lhs.legs == rhs.legs &&
                lhs.spread == rhs.spread
    }
}
