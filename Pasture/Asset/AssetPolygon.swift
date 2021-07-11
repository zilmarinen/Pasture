//
//  AssetPolygon.swift
//
//  Created by Zack Brown on 28/06/2021.
//

import Foundation

struct AssetPolygon: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case vertices = "v"
    }
    
    let vertices: [AssetVertex]
    
    init(vertices: [AssetVertex]) {
        
        self.vertices = vertices
    }
    
    public init(from decoder: Decoder) throws {
            
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        vertices = try container.decode([AssetVertex].self, forKey: .vertices)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(vertices, forKey: .vertices)
    }
}
