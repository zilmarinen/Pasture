//
//  ModelPolygon.swift
//
//  Created by Zack Brown on 24/04/2021.
//

import Foundation

struct ModelPolygon: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case vertices = "v"
    }
    
    let vertices: [ModelVertex]
    
    init(vertices: [ModelVertex]) {
        
        self.vertices = vertices
    }
    
    public init(from decoder: Decoder) throws {
            
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        vertices = try container.decode([ModelVertex].self, forKey: .vertices)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(vertices, forKey: .vertices)
    }
}
