//
//  AssetVertex.swift
//
//  Created by Zack Brown on 28/06/2021.
//

import Foundation
import Meadow

struct AssetVertex: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case position = "p"
        case normal = "n"
        case textureCoordinates = "uv"
    }
    
    let position: Vector
    let normal: Vector
    let textureCoordinates: Vector
    
    init(position: Vector, normal: Vector, textureCoordinates: Vector) {
        
        self.position = position
        self.normal = normal
        self.textureCoordinates = textureCoordinates
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        position = try container.decode(Vector.self, forKey: .position)
        normal = try container.decode(Vector.self, forKey: .normal)
        textureCoordinates = try container.decode(Vector.self, forKey: .textureCoordinates)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(position, forKey: .position)
        try container.encode(normal, forKey: .normal)
        try container.encode(textureCoordinates, forKey: .textureCoordinates)
    }
}
