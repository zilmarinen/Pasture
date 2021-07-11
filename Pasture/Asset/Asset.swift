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
    var polygons: [AssetPolygon]
    
    init(footprint: Footprint, polygons: [Euclid.Polygon]) {
        
        self.footprint = footprint
        self.polygons = polygons.map { AssetPolygon(vertices: $0.vertices.map { AssetVertex(position: Vector(x: $0.position.x, y: $0.position.y, z: $0.position.z), normal: Vector(x: $0.normal.x, y: $0.normal.y, z: $0.normal.z), textureCoordinates: Vector(x: $0.texcoord.x, y: $0.texcoord.y, z: $0.texcoord.z)) }) }
    }
    
    public init(from decoder: Decoder) throws {
           
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        polygons = try container.decode([AssetPolygon].self, forKey: .polygons)
    }
   
    public func encode(to encoder: Encoder) throws {
       
        var container = encoder.container(keyedBy: CodingKeys.self)
       
        try container.encode(footprint, forKey: .footprint)
        try container.encode(polygons, forKey: .polygons)
    }
}
