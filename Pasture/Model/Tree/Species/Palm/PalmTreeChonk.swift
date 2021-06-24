//
//  PalmTreeChonk.swift
//
//  Created by Zack Brown on 17/06/2021.
//

import SwiftUI

class PalmTreeChonk: Codable, Hashable, ObservableObject {
 
    enum CodingKeys: CodingKey {
        
        case segments
        case peak
        case base
        case baseRadius
        case peakRadius
    }
    
    @Published var segments: Int
    @Published var peak: Double
    @Published var base: Double
    @Published var baseRadius: Double
    @Published var peakRadius: Double
    
    init(segments: Int,
         peak: Double,
         base: Double,
         baseRadius: Double,
         peakRadius: Double) {
        
        self.segments = segments
        self.peak = peak
        self.base = base
        self.baseRadius = baseRadius
        self.peakRadius = peakRadius
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segments = try container.decode(Int.self, forKey: .segments)
        peak = try container.decode(Double.self, forKey: .peak)
        base = try container.decode(Double.self, forKey: .base)
        baseRadius = try container.decode(Double.self, forKey: .baseRadius)
        peakRadius = try container.decode(Double.self, forKey: .peakRadius)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(segments, forKey: .segments)
        try container.encode(peak, forKey: .peak)
        try container.encode(base, forKey: .base)
        try container.encode(baseRadius, forKey: .baseRadius)
        try container.encode(peakRadius, forKey: .peakRadius)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(segments)
        hasher.combine(peak)
        hasher.combine(base)
        hasher.combine(baseRadius)
        hasher.combine(peakRadius)
    }
    
    static func == (lhs: PalmTreeChonk, rhs: PalmTreeChonk) -> Bool {
        
        return  lhs.segments == rhs.segments &&
                lhs.peak == rhs.peak &&
                lhs.base == rhs.base &&
                lhs.baseRadius == rhs.baseRadius &&
                lhs.peakRadius == rhs.peakRadius
    }
}

extension PalmTreeChonk {
    
    static let crown: PalmTreeChonk = PalmTreeChonk(segments: 7,
                                                     peak: 0.056,
                                                     base: 0.01,
                                                     baseRadius: 0.042,
                                                     peakRadius: 0.105)
    
    static let segment: PalmTreeChonk = PalmTreeChonk(segments: 7,
                                                      peak: 0.049,
                                                      base: 0.01,
                                                      baseRadius: 0.035,
                                                      peakRadius: 0.014)
    
    static let throne: PalmTreeChonk = PalmTreeChonk(segments: 7,
                                                     peak: 0.07,
                                                     base: 0.01,
                                                     baseRadius: 0.28,
                                                     peakRadius: 0.14)
}
