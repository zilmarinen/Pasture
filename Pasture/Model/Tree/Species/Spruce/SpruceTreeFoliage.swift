//
//  SpruceTreeFoliage.swift
//  SpruceTreeFoliage
//
//  Created by Zack Brown on 02/08/2021.
//

import SwiftUI

class SpruceTreeFoliage: Codable, Hashable, ObservableObject {
    
    static let `default`: SpruceTreeFoliage = SpruceTreeFoliage(turns: 7,
                                                                segments: 7,
                                                                height: 1.25,
                                                                radius: 0.42,
                                                                thickness: 0.035)
    
    enum CodingKeys: CodingKey {
        
        case turns
        case segments
        case height
        case radius
        case thickness
    }
    
    @Published var turns: Int
    @Published var segments: Int
    @Published var height: Double
    @Published var radius: Double
    @Published var thickness: Double
    
    init(turns: Int,
         segments: Int,
         height: Double,
         radius: Double,
         thickness: Double) {
        
        self.turns = turns
        self.segments = segments
        self.height = height
        self.radius = radius
        self.thickness = thickness
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        turns = try container.decode(Int.self, forKey: .turns)
        segments = try container.decode(Int.self, forKey: .segments)
        height = try container.decode(Double.self, forKey: .height)
        radius = try container.decode(Double.self, forKey: .radius)
        thickness = try container.decode(Double.self, forKey: .thickness)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(turns, forKey: .turns)
        try container.encode(segments, forKey: .segments)
        try container.encode(height, forKey: .height)
        try container.encode(radius, forKey: .radius)
        try container.encode(thickness, forKey: .thickness)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(turns)
        hasher.combine(segments)
        hasher.combine(height)
        hasher.combine(radius)
        hasher.combine(thickness)
    }
    
    static func == (lhs: SpruceTreeFoliage, rhs: SpruceTreeFoliage) -> Bool {
        
        return  lhs.turns == rhs.turns &&
                lhs.segments == rhs.segments &&
                lhs.height == rhs.height &&
                lhs.radius == rhs.radius &&
                lhs.thickness == rhs.thickness
    }
}
