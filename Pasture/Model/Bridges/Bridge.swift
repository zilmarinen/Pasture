//
//  Bridge.swift
//
//  Created by Zack Brown on 16/08/2021.
//

import Euclid
import Foundation
import SwiftUI
import Meadow

class Bridge: Codable, Hashable, ObservableObject {
    
    static let `default`: Bridge = Bridge(material: .stone)
    
    enum CodingKeys: CodingKey {
        
        case material
    }
    
    @Published var material: BridgeMaterial = .stone
    
    init(material: BridgeMaterial) {
        
        self.material = material
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(BridgeMaterial.self, forKey: .material)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(material, forKey: .material)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(material)
    }
    
    static func == (lhs: Bridge, rhs: Bridge) -> Bool {
        
        return  lhs.material == rhs.material
    }
}

extension Bridge: Prop {
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch material {
            
        case .stone:
            
            let cornerLeft = BridgeCorner(material: material, side: .left, cardinals: [.north])
            let cornerRight = BridgeCorner(material: material, side: .right, cardinals: [.north])
            let cornerDual = BridgeCorner(material: material, side: .left, cardinals: [.north, .east])
            let edgeLeft = BridgeEdge(material: material, side: .left)
            let edgeRight = BridgeEdge(material: material, side: .right)
            let wall = BridgeWall(material: material)
            let path = BridgePath(material: material, cardinals: [])
            
            let cl = Mesh(cornerLeft.build(position: position + Vector(-3, 0, -2)))
            let cr = Mesh(cornerRight.build(position: position + Vector(-3, 0, 0)))
            let cd = Mesh(cornerDual.build(position: position + Vector(-3, 0, 2)))
            let el = Mesh(edgeLeft.build(position: position + Vector(-1, 0, -1)))
            let er = Mesh(edgeRight.build(position: position + Vector(-1, 0, 1)))
            let w = Mesh(wall.build(position: position + Vector(1, 0, 0)))
            let p = Mesh(path.build(position: position + Vector(3, 0, 0)))
            
            return cl.polygons + cr.polygons + cd.polygons + el.polygons + er.polygons + w.polygons + p.polygons
            
        default: return []
        }
    }
}
