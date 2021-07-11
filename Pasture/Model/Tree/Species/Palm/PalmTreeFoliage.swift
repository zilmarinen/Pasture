//
//  PalmTreeFoliage.swift
//
//  Created by Zack Brown on 21/06/2021.
//

import SwiftUI

class PalmTreeFoliage: Codable, Hashable, ObservableObject {
    
    static let `default`: PalmTreeFoliage = PalmTreeFoliage(fronds: 7)
 
    enum CodingKeys: CodingKey {
        
        case crown
        case frond
        case fronds
    }
    
    @Published var fronds: Int
    
    @Published var crown: PalmTreeChonk
    @Published var frond: PalmTreeFrond
    
    init(fronds: Int) {
        
        self.fronds = fronds
        self.crown = .crown
        self.frond = .default
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fronds = try container.decode(Int.self, forKey: .fronds)
        
        crown = try container.decode(PalmTreeChonk.self, forKey: .crown)
        frond = try container.decode(PalmTreeFrond.self, forKey: .frond)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fronds, forKey: .fronds)
        
        try container.encode(crown, forKey: .crown)
        try container.encode(frond, forKey: .frond)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(fronds)
        hasher.combine(crown)
        hasher.combine(frond)
    }
    
    static func == (lhs: PalmTreeFoliage, rhs: PalmTreeFoliage) -> Bool {
        
        return  lhs.fronds == rhs.fronds &&
                lhs.crown == rhs.crown &&
                lhs.frond == rhs.frond
    }
}
