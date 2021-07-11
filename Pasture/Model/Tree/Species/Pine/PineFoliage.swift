//
//  PineTreeFoliage.swift
//
//  Created by Zack Brown on 04/07/2021.
//

import SwiftUI

class PineTreeFoliage: Codable, Hashable, ObservableObject {
    
    static let `default`: PineTreeFoliage = PineTreeFoliage(slices: 7,
                                                            segments: 7,
                                                            height: 2,
                                                            flop: 0.1,
                                                            baseRadius: 0.5,
                                                            peakRadius: 0.4)
    
    enum CodingKeys: CodingKey {
        
        case slices
        case segments
        case height
        case flop
        case baseRadius
        case peakRadius
    }
    
    @Published var slices: Int
    @Published var segments: Int
    @Published var height: Double
    @Published var flop: Double
    @Published var baseRadius: Double
    @Published var peakRadius: Double
    
    init(slices: Int,
         segments: Int,
         height: Double,
         flop: Double,
         baseRadius: Double,
         peakRadius: Double) {
        
        self.slices = slices
        self.segments = segments
        self.height = height
        self.flop = flop
        self.baseRadius = baseRadius
        self.peakRadius = peakRadius
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        slices = try container.decode(Int.self, forKey: .slices)
        segments = try container.decode(Int.self, forKey: .segments)
        height = try container.decode(Double.self, forKey: .height)
        flop = try container.decode(Double.self, forKey: .flop)
        baseRadius = try container.decode(Double.self, forKey: .baseRadius)
        peakRadius = try container.decode(Double.self, forKey: .peakRadius)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(slices, forKey: .slices)
        try container.encode(segments, forKey: .segments)
        try container.encode(height, forKey: .height)
        try container.encode(flop, forKey: .flop)
        try container.encode(baseRadius, forKey: .baseRadius)
        try container.encode(peakRadius, forKey: .peakRadius)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(slices)
        hasher.combine(segments)
        hasher.combine(height)
        hasher.combine(flop)
        hasher.combine(baseRadius)
        hasher.combine(peakRadius)
    }
    
    static func == (lhs: PineTreeFoliage, rhs: PineTreeFoliage) -> Bool {
        
        return  lhs.slices == rhs.slices &&
                lhs.segments == rhs.segments &&
                lhs.height == rhs.height &&
                lhs.flop == rhs.flop &&
                lhs.baseRadius == rhs.baseRadius &&
                lhs.peakRadius == rhs.peakRadius
    }
}
