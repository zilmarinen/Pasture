//
//  Primitive.swift
//
//  Created by Zack Brown on 13/04/2021.
//

import Euclid
import Foundation

enum Primitive: Codable, Equatable {
    
    private enum CodingKeys: CodingKey {
        case type
        case size
        case radius
        case height
        case slices
        case stacks
        case poleDetail
    }
    
    enum Constants {
        
        static let epsilon = 0.05
    }
    
    @objc enum RawType: Int, Codable {
        
        case circle
        case quad
        
        case cone
        case cube
        case cylinder
        case sphere
        
        var description: String {
            
            switch self {
            
            case .circle: return "Circle"
            case .quad: return "Quad"
                
            case .cone: return "Cone"
            case .cube: return "Cube"
            case .cylinder: return "Cylinder"
            case .sphere: return "Sphere"
            }
        }
    }
    
    case circle(radius: Double, slices: Int)
    case quad(width: Double, height: Double)
    
    case cone(radius: Double, height: Double, slices: Int, poleDetail: Int)
    case cube(size: Vector)
    case cylinder(radius: Double, height: Double, slices: Int, poleDetail: Int)
    case sphere(radius: Double, slices: Int, stacks: Int, poleDetail: Int)
    
    var mesh: Mesh {
        
        switch self {
        
        case .circle(let radius, let slices):
            
            let radius = max(Constants.epsilon, radius)
            let slices = max(3, slices)
            
            let path = Path.circle(radius: radius, segments: slices)
            
            let polygon = Polygon(shape: path)!
            
            return Mesh([polygon])
            
        case .quad(let width, let height):
            
            let width = max(Constants.epsilon, width)
            let height = max(Constants.epsilon, height)
            
            let path = Path.rectangle(width: width, height: height)
            
            let polygon = Polygon(shape: path)!
            
            return Mesh([polygon])
        
        case .cone(let radius, let height, let slices, let poleDetail):
            
            let radius = max(Constants.epsilon, radius)
            let height = max(Constants.epsilon, height)
            let slices = max(3, slices)
            let poleDetail = max(0, poleDetail)
            
            return Mesh.cone(radius: radius, height: height, slices: slices, poleDetail: poleDetail, addDetailAtBottomPole: true, faces: .front)
            
        case .cube(let size):
            
            let size = Vector(max(size.x, Constants.epsilon), max(size.y, Constants.epsilon), max(size.z, Constants.epsilon))
            
            return Mesh.cube(size: size, faces: .front)
            
        case .cylinder(let radius, let height, let slices, let poleDetail):
            
            let radius = max(Constants.epsilon, radius)
            let height = max(Constants.epsilon, height)
            let slices = max(3, slices)
            let poleDetail = max(0, poleDetail)
            
            return Mesh.cylinder(radius: radius, height: height, slices: slices, poleDetail: poleDetail, faces: .front)
            
        case .sphere(let radius, let slices, let stacks, let poleDetail):
            
            let radius = max(Constants.epsilon, radius)
            let slices = max(3, slices)
            let stacks = max(3, stacks)
            let poleDetail = max(0, poleDetail)
            
            return Mesh.sphere(radius: radius, slices: slices, stacks: stacks, poleDetail: poleDetail, faces: .front)
        }
    }
    
    var rawType: RawType {
        
        switch self {
        
        case .circle: return .circle
        case .quad: return .quad
        
        case .cone: return .cone
        case .cube: return .cube
        case .cylinder: return .cylinder
        case .sphere: return .sphere
        }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(RawType.self, forKey: .type)
        let radius = try container.decode(Double.self, forKey: .radius)
        let height = try container.decode(Double.self, forKey: .height)
        let slices = try container.decode(Int.self, forKey: .slices)
        let stacks = try container.decode(Int.self, forKey: .stacks)
        let poleDetail = try container.decode(Int.self, forKey: .poleDetail)
        let size = try container.decode(Vector.self, forKey: .size)
        
        switch type {
        
        case .circle:
            
            self = .circle(radius: radius, slices: slices)
            
        case .quad:
            
            self = .quad(width: size.x, height: size.y)
        
        case .cone:
            
            self = .cone(radius: radius, height: height, slices: slices, poleDetail: poleDetail)
            
        case .cube:
            
            self = .cube(size: size)
            
        case .cylinder:
            
            self = .cylinder(radius: radius, height: height, slices: slices, poleDetail: poleDetail)
            
        case .sphere:
            
            self = .sphere(radius: radius, slices: slices, stacks: stacks, poleDetail: poleDetail)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(rawType, forKey: .type)
        
        switch self {
        
        case .circle(let radius, let slices):
            
            try container.encode(radius, forKey: .radius)
            try container.encode(0, forKey: .height)
            try container.encode(slices, forKey: .slices)
            try container.encode(0, forKey: .stacks)
            try container.encode(0, forKey: .poleDetail)
            try container.encode(Vector.zero, forKey: .size)
            
        case .quad(let width, let height):
            
            try container.encode(0, forKey: .radius)
            try container.encode(0, forKey: .height)
            try container.encode(0, forKey: .slices)
            try container.encode(0, forKey: .stacks)
            try container.encode(0, forKey: .poleDetail)
            try container.encode(Vector(width, height), forKey: .size)
        
        case .cone(let radius, let height, let slices, let poleDetail),
             .cylinder(let radius, let height, let slices, let poleDetail):
            
            try container.encode(radius, forKey: .radius)
            try container.encode(height, forKey: .height)
            try container.encode(slices, forKey: .slices)
            try container.encode(0, forKey: .stacks)
            try container.encode(poleDetail, forKey: .poleDetail)
            try container.encode(Vector.zero, forKey: .size)
            
        case .cube(let size):
        
            try container.encode(0, forKey: .radius)
            try container.encode(0, forKey: .height)
            try container.encode(0, forKey: .slices)
            try container.encode(0, forKey: .stacks)
            try container.encode(0, forKey: .poleDetail)
            try container.encode(size, forKey: .size)
            
        case .sphere(let radius, let slices, let stacks, let poleDetail):
            
            try container.encode(radius, forKey: .radius)
            try container.encode(0, forKey: .height)
            try container.encode(slices, forKey: .slices)
            try container.encode(stacks, forKey: .stacks)
            try container.encode(poleDetail, forKey: .poleDetail)
            try container.encode(Vector.zero, forKey: .size)
        }
    }
}
