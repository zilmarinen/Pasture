//
//  Stairs.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Euclid
import Foundation
import SwiftUI
import Meadow

class Stairs: Codable, Hashable, ObservableObject {
    
    static let `default`: Stairs = Stairs(style: .sloped_1x1,
                                          material: .stone)
    
    enum CodingKeys: CodingKey {
        
        case style
        case material
    }
    
    var footprint: Footprint { style.footprint }
    
    @Published var style: StairType = .sloped_1x1
    @Published var material: StairMaterial = .stone
    
    init(style: StairType,
         material: StairMaterial) {
        
        self.style = style
        self.material = material
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        style = try container.decode(StairType.self, forKey: .style)
        material = try container.decode(StairMaterial.self, forKey: .material)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(style, forKey: .style)
        try container.encode(material, forKey: .material)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(style)
        hasher.combine(material)
    }
    
    static func == (lhs: Stairs, rhs: Stairs) -> Bool {
        
        return  lhs.style == rhs.style &&
                lhs.material == rhs.material
    }
}

extension Stairs: Prop {
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch material {
            
        case .stone:
            
            return StoneStairs(style: style).build(position: position)
        }
    }
}
