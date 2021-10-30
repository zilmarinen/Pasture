//
//  Walls.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Euclid
import Foundation
import SwiftUI
import Meadow

class Walls: Codable, Hashable, ObservableObject {
    
    static let `default`: Walls = Walls(style: .concrete)
    
    enum CodingKeys: CodingKey {
        
        case style
    }
    
    @Published var style: WallMaterial = .concrete
    
    init(style: WallMaterial) {
        
        self.style = style
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        style = try container.decode(WallMaterial.self, forKey: .style)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(style, forKey: .style)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(style)
    }
    
    static func == (lhs: Walls, rhs: Walls) -> Bool {
        
        return  lhs.style == rhs.style
    }
}

extension Walls: Prop {
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let corner1 = Corner(style: style, cardinals: [.north])
        let corner2 = Corner(style: style, cardinals: [.north, .east])
        let corner3 = Corner(style: style, cardinals: [.north, .east, .south])
        let corner4 = Corner(style: style, cardinals: Cardinal.allCases)
        
        let edgeExternalLeft = Edge(style: style, side: .left, external: true)
        let edgeExternalRight = Edge(style: style, side: .right, external: true)
        let edgeInternal = Edge(style: style, side: .left, external: false)
        
        let wallExternal = Wall(style: style, external: true)
        let wallInternal = Wall(style: style, external: false)
        
        let c0 = Mesh(corner1.build(position: position + Vector(-2, 0, -3)))
        let c1 = Mesh(corner2.build(position: position + Vector(-2, 0, -1)))
        let c2 = Mesh(corner3.build(position: position + Vector(-2, 0, 1)))
        let c3 = Mesh(corner4.build(position: position + Vector(-2, 0, 3)))
        
        let eel = Mesh(edgeExternalLeft.build(position: position + Vector(0, 0, -2)))
        let eer = Mesh(edgeExternalRight.build(position: position + Vector(0, 0, 0)))
        let ei = Mesh(edgeInternal.build(position: position + Vector(0, 0, 2)))
        
        let we = Mesh(wallExternal.build(position: position + Vector(2, 0, -1)))
        let wi = Mesh(wallInternal.build(position: position + Vector(2, 0, 1)))
        
        return c0.polygons + c1.polygons + c2.polygons + c3.polygons + eel.polygons + eer.polygons + ei.polygons + we.polygons + wi.polygons
    }
}
