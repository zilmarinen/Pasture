//
//  Asset.swift
//
//  Created by Zack Brown on 28/06/2021.
//

import Euclid
import Foundation
import Meadow

struct Asset: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case footprint = "f"
        case polygons = "p"
    }
    
    var footprint: Footprint
    var polygons: [Euclid.Polygon]
    
    init(footprint: Footprint, polygons: [Euclid.Polygon]) {
        
        self.footprint = footprint
        self.polygons = polygons
    }
    
    public init(from decoder: Decoder) throws {
           
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        polygons = try container.decode([Euclid.Polygon].self, forKey: .polygons)
    }
   
    public func encode(to encoder: Encoder) throws {
       
        var container = encoder.container(keyedBy: CodingKeys.self)
       
        try container.encode(footprint, forKey: .footprint)
        try container.encode(polygons, forKey: .polygons)
    }
}
