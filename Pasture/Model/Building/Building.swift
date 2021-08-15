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
    
    static let `default`: Building = Building(architecture: .bernina,
                                              zachomino: .z,
                                              layers: 1,
                                              roof: .hip(direction: .north))
    
    enum CodingKeys: CodingKey {
        
        case architecture
        case zachomino
        case layers
        case roof
    }
    
    enum Architecture: CaseIterable, Codable, Hashable, Identifiable {
        
        enum MasonryStyle {
            
            case pillar(angled: Bool)
            case plain
            case quoins(angled: Bool, layers: Int)
        }
        
        enum BorderStyle {
            
            case pointy
            case rounded
            case square
        }
        
        case bernina
        case daisen
        case elna
        case juki
        case merrow
        case necchi
        case singer
        
        var id: String {
            
            switch self {

            case .bernina: return "Bernina"
            case .daisen: return "Daisen"
            case .elna: return "Elna"
            case .juki: return "Juki"
            case .merrow: return "Merrow"
            case .necchi: return "Necchi"
            case .singer: return "Singer"
            }
        }
        
        var texture: Texture? {
            
            guard let image = MDWImage.asset(named: id.lowercased() + "_building", in: .main) else { return nil }
            
            return Texture(key: "building", image: image)
        }
        
        var angled: Bool {
            
            switch self {

            case .bernina,
                    .elna,
                    .singer: return true
            
            default: return false
            }
        }
        
        var masonryStyle: MasonryStyle {
            
            switch self {

            case .bernina: return .pillar(angled: angled)
            case .daisen: return .quoins(angled: angled, layers: 14)
            case .elna: return .quoins(angled: angled, layers: 14)
            case .juki: return .pillar(angled: angled)
            case .necchi: return .pillar(angled: angled)
            case .singer: return .quoins(angled: angled, layers: 7)
            default: return .plain
            }
        }
        
        var borderStyle: BorderStyle {
            
            switch self {

            case .bernina: return .square
            case .daisen: return .pointy
            case .elna: return .rounded
            case .juki: return .square
            case .necchi: return .pointy
            case .singer: return .rounded
            default: return .square
            }
        }
    }
    
    var footprint: Footprint { zachomino.footprint }
                                                
    @Published var architecture: Architecture = .bernina
    @Published var zachomino: Zachomino
    @Published var layers: Int
    @Published var roof: BuildingRoof.Style
    
    init(architecture: Architecture,
         zachomino: Zachomino,
         layers: Int,
         roof: BuildingRoof.Style) {
        
        self.architecture = architecture
        self.zachomino = zachomino
        self.layers = layers
        self.roof = roof
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        architecture = try container.decode(Architecture.self, forKey: .architecture)
        zachomino = try container.decode(Zachomino.self, forKey: .zachomino)
        layers = try container.decode(Int.self, forKey: .layers)
        roof = try container.decode(BuildingRoof.Style.self, forKey: .roof)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(architecture, forKey: .architecture)
        try container.encode(zachomino, forKey: .zachomino)
        try container.encode(layers, forKey: .layers)
        try container.encode(roof, forKey: .roof)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(architecture)
        hasher.combine(zachomino)
        hasher.combine(layers)
        hasher.combine(roof)
    }
    
    static func == (lhs: Building, rhs: Building) -> Bool {
        
        return  lhs.architecture == rhs.architecture &&
                lhs.zachomino == rhs.zachomino &&
                lhs.layers == rhs.layers &&
                lhs.roof == rhs.roof
    }
}

extension Building {
    
    enum Element: Int, Codable {
        
        case corner = -2
        case door = 3
        case empty = 0
        case wall = 1
        case window = 2
    }
    
    func collapse() -> [Coordinate : GridPattern<Element>] {
        
        var nodes: [Coordinate : GridPattern<Element>] = [:]
        
        //
        /// Create patterns for outer corners and edges
        //
        
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
        
        //
        /// Create patterns for windows and doors
        //
        
        for (node, pattern) in nodes.shuffled(using: &rng) {
            
            var elements: [Building.Element] = [.wall, .window, .window, .door]
            
            var potentialDoor = true
            
            for cardinal in Cardinal.allCases {
                
                let neighbour = nodes[node + cardinal.coordinate]
                
                potentialDoor = !(neighbour?.contains(element: .door) ?? false)
            }
            
            if !potentialDoor {
                
                elements.removeAll { $0 == .door }
            }
            
            for cardinal in Cardinal.allCases {
             
                guard pattern.value(for: cardinal) != .empty,
                      !elements.isEmpty,
                      let element = elements.last,
                      let index = elements.firstIndex(of: element) else { continue }
                
                switch element {
                    
                case .door:
                    
                    let (c0, c1) = cardinal.cardinals
                    
                    guard pattern.value(for: c0) == .empty,
                          pattern.value(for: c1) == .empty else { continue }
                 
                    elements.remove(at: index)
                    
                    nodes[node]?.set(value: element, cardinal: cardinal)
                    
                case .window:
                    
                    elements.remove(at: index)
                    print("WINDOW!")
                    nodes[node]?.set(value: element, cardinal: cardinal)
                    
                default: break
                }
            }
        }
        
        return nodes
    }
}

extension Building: Prop {
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let configuration = collapse()
        
        let wallTextureCoordinates = UVs(start: Vector(0, 0.5), end: Vector(0.5, 1))
        let roofTextureCoordinates = UVs(start: .zero, end: Vector(0.5, 0.5))
        let borderTextureCoordinates = UVs(start: Vector(0.5, 0.375), end: Vector(1.0, 0.5))
        let corniceTextureCoordinates = UVs(start: Vector(0.5, 0.25), end: Vector(1.0, 0.375))
        
        let shell = BuildingShell(configuration: configuration, architecture: architecture, layers: layers, height: (World.Constants.slope * 4), inset: BuildingShell.Constants.wallInset, angled: architecture.angled, cornerStyle: architecture.masonryStyle, cutaways: true, uvs: (wallTextureCoordinates, borderTextureCoordinates, roofTextureCoordinates))
        
        var mesh = Euclid.Mesh(shell.build(position: position))
        
        let borderHeight = (World.Constants.slope / 4)
        let corniceHeight = (World.Constants.slope / 4)
        
        let border = BuildingShell(configuration: configuration, architecture: architecture, layers: 1, height: borderHeight, inset: BuildingShell.Constants.borderInset, angled: shell.angled, cornerStyle: .plain, cutaways: false, uvs: (borderTextureCoordinates, borderTextureCoordinates, borderTextureCoordinates))
        
        mesh = mesh.union(Mesh(border.build(position: position)))
        
        let cornice = BuildingShell(configuration: configuration, architecture: architecture, layers: 1, height: corniceHeight, inset: BuildingShell.Constants.corniceInset, angled: shell.angled, cornerStyle: .plain, cutaways: false, uvs: (corniceTextureCoordinates, corniceTextureCoordinates, corniceTextureCoordinates))
        
        for layer in 0..<layers {
            
            mesh = mesh.union(Mesh(cornice.build(position: position + Vector(0, ((Double(layer + 1) * (World.Constants.slope * 4)) - corniceHeight), 0))))
        }
        
        let roof = BuildingRoof(footprint: footprint, configuration: configuration, architecture: architecture, style: roof)
        
        mesh = mesh.union(Mesh(roof.build(position: position + Vector(0, (Double(layers) * (World.Constants.slope * 4)), 0))))
        
        return mesh.polygons
    }
}
