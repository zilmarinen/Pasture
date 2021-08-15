//
//  Trunk.swift
//
//  Created by Zack Brown on 01/07/2021.
//

import SwiftUI

class Trunk: Codable, Hashable, ObservableObject {
    
    static let `default`: Trunk = Trunk(segments: 7,
                                        slices: 7,
                                        height: 1,
                                        baseRadius: 0.3,
                                        peakRadius: 0.2,
                                        spread: 0.1)
    
    static let spruce: Trunk = Trunk(segments: 7,
                                     slices: 7,
                                     height: 1.5,
                                     baseRadius: 0.14,
                                     peakRadius: 0.028,
                                     spread: 0.1)
    
    enum CodingKeys: CodingKey {
        
        case segments
        case slices
        case height
        case baseRadius
        case peakRadius
        case spread
    }
    
    @Published var segments: Int
    @Published var slices: Int
    @Published var height: Double
    @Published var baseRadius: Double
    @Published var peakRadius: Double
    @Published var spread: Double
    
    init(segments: Int,
         slices: Int,
         height: Double,
         baseRadius: Double,
         peakRadius: Double,
         spread: Double) {
        
        self.segments = segments
        self.slices = slices
        self.height = height
        self.baseRadius = baseRadius
        self.peakRadius = peakRadius
        self.spread = spread
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segments = try container.decode(Int.self, forKey: .segments)
        slices = try container.decode(Int.self, forKey: .slices)
        height = try container.decode(Double.self, forKey: .height)
        baseRadius = try container.decode(Double.self, forKey: .baseRadius)
        peakRadius = try container.decode(Double.self, forKey: .peakRadius)
        spread = try container.decode(Double.self, forKey: .spread)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(segments, forKey: .segments)
        try container.encode(slices, forKey: .slices)
        try container.encode(height, forKey: .height)
        try container.encode(baseRadius, forKey: .baseRadius)
        try container.encode(peakRadius, forKey: .peakRadius)
        try container.encode(spread, forKey: .spread)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(segments)
        hasher.combine(slices)
        hasher.combine(height)
        hasher.combine(baseRadius)
        hasher.combine(peakRadius)
        hasher.combine(spread)
    }
    
    static func == (lhs: Trunk, rhs: Trunk) -> Bool {
        
        return  lhs.segments == rhs.segments &&
                lhs.slices == rhs.slices &&
                lhs.height == rhs.height &&
                lhs.baseRadius == rhs.baseRadius &&
                lhs.peakRadius == rhs.peakRadius &&
                lhs.spread == rhs.spread
    }
}
