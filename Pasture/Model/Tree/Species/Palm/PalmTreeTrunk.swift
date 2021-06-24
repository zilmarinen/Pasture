//
//  PalmTreeTrunk.swift
//
//  Created by Zack Brown on 14/06/2021.
//

import AppKit
import Euclid
import Foundation
import Meadow

class PalmTreeTrunk: Codable, Hashable, ObservableObject {
 
    enum CodingKeys: CodingKey {
        
        case slices
        case spread
        case height
        case throne
        case segment
    }
    
    @Published var slices: Int
    @Published var spread: Double
    @Published var height: Double
    @Published var throne: PalmTreeChonk
    @Published var segment: PalmTreeChonk
    
    init(slices: Int,
         spread: Double,
         height: Double) {
        
        self.slices = slices
        self.spread = spread
        self.height = height
        self.throne = .throne
        self.segment = .segment
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        slices = try container.decode(Int.self, forKey: .slices)
        spread = try container.decode(Double.self, forKey: .spread)
        height = try container.decode(Double.self, forKey: .height)
        
        throne = try container.decode(PalmTreeChonk.self, forKey: .throne)
        segment = try container.decode(PalmTreeChonk.self, forKey: .segment)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(slices, forKey: .slices)
        try container.encode(spread, forKey: .spread)
        try container.encode(height, forKey: .height)
        
        try container.encode(throne, forKey: .throne)
        try container.encode(segment, forKey: .segment)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(slices)
        hasher.combine(spread)
        hasher.combine(height)
        
        hasher.combine(throne)
        hasher.combine(segment)
    }
    
    static func == (lhs: PalmTreeTrunk, rhs: PalmTreeTrunk) -> Bool {
        
        return  lhs.slices == rhs.slices &&
                lhs.spread == rhs.spread &&
                lhs.height == rhs.height &&
                lhs.throne == rhs.throne &&
                lhs.segment == rhs.segment
    }
}

extension PalmTreeTrunk {
    
    static let `default`: PalmTreeTrunk = PalmTreeTrunk(slices: 7,
                                                        spread: 0.1,
                                                        height: 2.0)
}

