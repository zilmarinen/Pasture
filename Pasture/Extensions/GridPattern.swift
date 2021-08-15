//
//  GridPattern.swift
//
//  Created by Zack Brown on 28/07/2021.
//

import Meadow

extension GridPattern where T == Building.Element {
    
    var score: Int {
        
        return  max(value(for: .north).rawValue, 0) +
                max(value(for: .east).rawValue, 0) +
                max(value(for: .south).rawValue, 0) +
                max(value(for: .west).rawValue, 0)
    }
    
    func contains(element: Building.Element) -> Bool {
        
        return  value(for: .north) == element ||
                value(for: .east) == element ||
                value(for: .south) == element ||
                value(for: .west) == element
    }
}
