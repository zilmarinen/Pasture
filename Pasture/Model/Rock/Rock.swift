//
//  Rock.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import Euclid
import Foundation
import SwiftUI
import Meadow

class Rock: Codable, Hashable, ObservableObject {
    
    static let `default`: Rock = Rock(category: .causeway(.default))
    
    enum CodingKeys: CodingKey {
        
        case category
    }
    
    enum Category: CaseIterable, Codable, Hashable, Identifiable {
        
        static var allCases: [Rock.Category] { [.causeway(.default)] }
        
        case causeway(Causeway)
        
        var id: String {
            
            switch self {

            case .causeway: return "Causeway"
            }
        }
        
        var texture: Texture? {
            
            guard let image = MDWImage.asset(named: id.lowercased() + "_rock", in: .main) else { return nil }
            
            return Texture(key: "foliage", image: image)
        }
    }
    
    var footprint: Footprint {
        
        switch category {
            
        case .causeway(let rock): return rock.pentomino.footprint
        }
    }
                                                
    @Published var category: Category = .causeway(.default)
    
    init(category: Category) {
        
        self.category = category
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        category = try container.decode(Category.self, forKey: .category)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(category, forKey: .category)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(category)
    }
    
    static func == (lhs: Rock, rhs: Rock) -> Bool {
        
        return  lhs.category == rhs.category
    }
}

extension Rock {
    
    var causeway: Causeway {
        
        get {
            
            switch self.category {
                
            case .causeway(let rock): return rock
                
            default: return .default
            }
        }
        set {
            
            self.category = .causeway(newValue)
        }
    }
}

extension Rock: Prop {
    
    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
        
        switch category {
            
        case .causeway(let rock): return rock.build(position: position)
        }
    }
}
