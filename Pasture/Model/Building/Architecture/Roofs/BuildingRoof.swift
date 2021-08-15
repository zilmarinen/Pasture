//
//  BuildingRoof.swift
//
//  Created by Zack Brown on 22/07/2021.
//

import Euclid
import Foundation
import Meadow

struct BuildingRoof: Prop {
    
    enum Style: CaseIterable, Codable, Hashable, Identifiable {
        
        static var allCases: [BuildingRoof.Style] = [.flat,
                                                     .hip(direction: .north),
                                                     .jerkinhead(direction: .north),
                                                     .mansard(direction: .north),
                                                     .saltbox(direction: .east, peak: .right),
                                                     .skillion(direction: .north)]
        
        case flat
        case hip(direction: Cardinal)
        case jerkinhead(direction: Cardinal)
        case mansard(direction: Cardinal)
        case saltbox(direction: Cardinal, peak: SaltboxRoof.Peak)
        case skillion(direction: Cardinal)
        
        var id: String {
            
            switch self {

            case .flat: return "Flat"
            case .hip: return "Hip"
            case .jerkinhead: return "Jerkinhead"
            case .mansard: return "Mansard"
            case .saltbox: return "Saltbox"
            case .skillion: return "Skillion"
            }
        }
        
        var direction: Cardinal {
            
            get {
                
                switch self {
                    
                case .hip(let direction),
                        .jerkinhead(let direction),
                        .mansard(let direction),
                        .saltbox(let direction, _),
                        .skillion(let direction):
                    
                    return direction
                    
                default: return .north
                }
            }
            set {
                
                switch self {
                    
                case .hip: self = .hip(direction: newValue)
                case .jerkinhead: self = .jerkinhead(direction: newValue)
                case .mansard: self = .mansard(direction: newValue)
                case .saltbox(_, let peak): self = .saltbox(direction: newValue, peak: peak)
                case .skillion: self = .skillion(direction: newValue)
                    
                default: break
                }
            }
        }
        
        var peak: SaltboxRoof.Peak {
            
            get {
                
                switch self {
                    
                case .saltbox(_, let peak): return peak
                    
                default: return .left
                }
            }
            set {
                
                switch self {
                    
                case .saltbox(let direction, _): self = .saltbox(direction: direction, peak: newValue)
                    
                default: break
                }
            }
        }
    }
    
    let footprint: Footprint
    
    let configuration: [Coordinate : GridPattern<Building.Element>]
    
    let architecture: Building.Architecture
    
    let style: Style
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        switch style {
            
        case .flat:
            
            let roof = FlatRoof(configuration: configuration, architecture: architecture, height: World.Constants.slope / 2, inset: BuildingShell.Constants.wallInset)
            
            return roof.build(position: position)
            
        case .saltbox(let direction, let peak):
            
            let roof = SaltboxRoof(footprint: footprint, configuration: configuration, architecture: architecture, height: World.Constants.slope / 4, slope: World.Constants.slope, inset: BuildingShell.Constants.wallInset, direction: direction, peak: peak)
            
            return roof.build(position: position)
            
        case .skillion(let direction):
            
            let roof = SkillionRoof(footprint: footprint, configuration: configuration, architecture: architecture, height: World.Constants.slope / 4, slope: World.Constants.slope, inset: BuildingShell.Constants.wallInset, direction: direction)
            
            return roof.build(position: position)
        
        default: return []
        }
    }
}
