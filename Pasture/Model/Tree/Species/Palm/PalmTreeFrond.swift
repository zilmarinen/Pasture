//
//  PalmTreeFrond.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import SwiftUI

class PalmTreeFrond: Codable, Hashable, ObservableObject {
    
    static let `default`: PalmTreeFrond = PalmTreeFrond(segments: 7,
                                                        radius: 0.42,
                                                        width: 0.14,
                                                        thickness: 0.014,
                                                        spread: 0.014)
    
    enum CodingKeys: CodingKey {
        
        case segments
        case radius
        case width
        case thickness
        case spread
    }
    
    @Published var segments: Int
    @Published var radius: Double
    @Published var width: Double
    @Published var thickness: Double
    @Published var spread: Double
    
    init(segments: Int,
         radius: Double,
         width: Double,
         thickness: Double,
         spread: Double) {
        
        self.segments = segments
        self.radius = radius
        self.width = width
        self.thickness = thickness
        self.spread = spread
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segments = try container.decode(Int.self, forKey: .segments)
        radius = try container.decode(Double.self, forKey: .radius)
        width = try container.decode(Double.self, forKey: .width)
        thickness = try container.decode(Double.self, forKey: .thickness)
        spread = try container.decode(Double.self, forKey: .spread)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(segments, forKey: .segments)
        try container.encode(radius, forKey: .radius)
        try container.encode(width, forKey: .width)
        try container.encode(thickness, forKey: .thickness)
        try container.encode(spread, forKey: .spread)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(segments)
        hasher.combine(radius)
        hasher.combine(width)
        hasher.combine(thickness)
        hasher.combine(spread)
    }
    
    static func == (lhs: PalmTreeFrond, rhs: PalmTreeFrond) -> Bool {
        
        return  lhs.segments == rhs.segments &&
                lhs.radius == rhs.radius &&
                lhs.width == rhs.width &&
                lhs.thickness == rhs.thickness &&
                lhs.spread == rhs.spread
    }
}
