//
//  Noise.swift
//
//  Created by Zack Brown on 30/06/2021.
//

import Euclid
import Foundation
import GameKit

class Noise: Codable, Hashable, ObservableObject {
    
    static let `default`: Noise = Noise(frequency: 8,
                                        octaveCount: 4,
                                        persistence: 0.21,
                                        lacunarity: 2,
                                        seed: 1337)
    
    enum CodingKeys: CodingKey {
        
        case frequency
        case octaveCount
        case persistence
        case lacunarity
        case seed
    }
    
    @Published var frequency: Double
    @Published var octaveCount: Int
    @Published var persistence: Double
    @Published var lacunarity: Double
    @Published var seed: Int32
    
    init(frequency: Double,
         octaveCount: Int,
         persistence: Double,
         lacunarity: Double,
         seed: Int32) {
        
        self.frequency = frequency
        self.octaveCount = octaveCount
        self.persistence = persistence
        self.lacunarity = lacunarity
        self.seed = seed
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        frequency = try container.decode(Double.self, forKey: .frequency)
        octaveCount = try container.decode(Int.self, forKey: .octaveCount)
        persistence = try container.decode(Double.self, forKey: .persistence)
        lacunarity = try container.decode(Double.self, forKey: .lacunarity)
        seed = try container.decode(Int32.self, forKey: .seed)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(frequency, forKey: .frequency)
        try container.encode(octaveCount, forKey: .octaveCount)
        try container.encode(persistence, forKey: .persistence)
        try container.encode(lacunarity, forKey: .lacunarity)
        try container.encode(seed, forKey: .seed)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(frequency)
        hasher.combine(octaveCount)
        hasher.combine(persistence)
        hasher.combine(lacunarity)
        hasher.combine(seed)
    }
    
    static func == (lhs: Noise, rhs: Noise) -> Bool {
        
        return  lhs.frequency == rhs.frequency &&
                lhs.octaveCount == rhs.octaveCount &&
                lhs.persistence == rhs.persistence &&
                lhs.lacunarity == rhs.lacunarity &&
                lhs.seed == rhs.seed
    }
}

extension Noise {
    
    func map(size: Vector, sampleCount: Vector, origin: Vector = .zero) -> GKNoiseMap {
        
        let source = GKBillowNoiseSource(frequency: frequency, octaveCount: octaveCount, persistence: persistence, lacunarity: lacunarity, seed: seed)
        
        let noise = GKNoise(source)
        
        return GKNoiseMap(noise, size: vector2(size.x, size.z), origin: vector2(Double(origin.x), Double(origin.z)), sampleCount: vector2(Int32(sampleCount.x), Int32(sampleCount.z)), seamless: true)
    }
}
