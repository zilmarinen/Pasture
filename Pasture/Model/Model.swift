//
//  Model.swift
//
//  Created by Zack Brown on 04/04/2021.
//

import Foundation

class Model: Codable, StartOption {
    
    private enum CodingKeys: CodingKey {
        
        case name
    }
    
    var name: String = ""
    
    init() {
        
        //
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
    }
}
