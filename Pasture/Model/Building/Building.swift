//
//  Building.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import Euclid
import Foundation
import SwiftUI
import Meadow

class Building: Codable, Hashable, ObservableObject {
    
    static let `default`: Building = Building(architecture: .brownstead,
                                              zachomino: .z,
                                              layers: 1)
    
    enum CodingKeys: CodingKey {
        
        case architecture
        case zachomino
        case layers
    }
    
    enum Architecture: CaseIterable, Codable, Hashable, Identifiable {
        
        case brownstead
        
        var id: String {
            
            switch self {

            case .brownstead: return "Brownstead"
            }
        }
        
        var texture: Texture? {
            
            //guard let image = MDWImage.asset(named: id.lowercased() + "_building", in: .main) else { return nil }
            guard let image = MDWImage.asset(named: "uvs", in: .main) else { return nil }
            
            return Texture(key: "building", image: image)
        }
    }
    
    var footprint: Footprint { zachomino.footprint }
                                                
    @Published var architecture: Architecture = .brownstead
    @Published var zachomino: Zachomino
    @Published var layers: Int
    
    init(architecture: Architecture,
         zachomino: Zachomino,
         layers: Int) {
        
        self.architecture = architecture
        self.zachomino = zachomino
        self.layers = layers
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        architecture = try container.decode(Architecture.self, forKey: .architecture)
        zachomino = try container.decode(Zachomino.self, forKey: .zachomino)
        layers = try container.decode(Int.self, forKey: .layers)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(architecture, forKey: .architecture)
        try container.encode(zachomino, forKey: .zachomino)
        try container.encode(layers, forKey: .layers)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(architecture)
        hasher.combine(zachomino)
        hasher.combine(layers)
    }
    
    static func == (lhs: Building, rhs: Building) -> Bool {
        
        return  lhs.architecture == rhs.architecture &&
                lhs.zachomino == rhs.zachomino &&
                lhs.layers == rhs.layers
    }
}

extension Building {
    
    enum Element: Int, Codable {
        
        case corner
        case door
        case empty
        case wall
        case window
    }
    
    func collapse() -> [Coordinate : GridPattern<Element>] {
        
        var nodes: [Coordinate : GridPattern<Element>] = [:]
        
        for node in footprint.nodes {
            
            var pattern = GridPattern(value: Element.wall)
            
            for cardinal in Cardinal.allCases {
                
                guard footprint.intersects(coordinate: node + cardinal.coordinate) else { continue }
                
                pattern.set(value: Element.empty, cardinal: cardinal)
            }
            
            for ordinal in Ordinal.allCases {
                
                let (c0, c1) = ordinal.cardinals
                
                let n0 = footprint.intersects(coordinate: node + ordinal.coordinate)
                let n1 = footprint.intersects(coordinate: node + c0.coordinate)
                let n2 = footprint.intersects(coordinate: node + c1.coordinate)
                
                let element = n0 && n1 && n2 ? Element.empty : (!n0 && !n1 && !n2) || (!n0 && n1 && n2) ? Element.corner : Element.wall
                
                pattern.set(value: element, ordinal: ordinal)
            }
            
            nodes[node] = pattern
        }
        
        return nodes
    }
}

extension Building: Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        let configuration = collapse()
        
        print("Architecture: \(architecture.id)")
        
        let textureCoordinates = UVs(start: Vector(x: 0.0, y: 0.0, z: 0.0), end: Vector(x: 1.0, y: 1.0, z: 0.0))
        
        let shell = BuildingShell(configuration: configuration, layers: layers, height: (World.Constants.slope * 4), cornerInset: 0.05, edgeInset: 0.05, angled: true, textureCoordinates: textureCoordinates)
        
        var mesh = Euclid.Mesh(shell.build(position: position))
        
        let corniceHeight = (World.Constants.slope / 4)
        
        let cornice = BuildingShell(configuration: configuration, layers: 1, height: corniceHeight, cornerInset: 0.02, edgeInset: 0.02, angled: shell.angled, textureCoordinates: textureCoordinates)
        
        for layer in 0..<layers {
            
            mesh = mesh.union(Mesh(cornice.build(position: position + Vector(0, (Double(layer + 1) * (World.Constants.slope * 4)) - corniceHeight, 0))))
        }
        
        let roof = BuildingRoof(footprint: footprint, configuration: configuration, style: .flat(inset: 0.1, angled: shell.angled))
        
        mesh = mesh.union(Mesh(roof.build(position: position + Vector(0, (Double(layers) * (World.Constants.slope * 4)), 0))))
        
        return mesh.polygons
    }
}
