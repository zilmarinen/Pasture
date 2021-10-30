//
//  Ordinal.swift
//  Ordinal
//
//  Created by Zack Brown on 20/09/2021.
//

import Meadow

extension Ordinal {
    
    public var next: Ordinal { self == .northWest ? .northEast : self == .northEast ? .southEast : self == .southEast ? .southWest : .northWest }
    public var previous: Ordinal { self == .northWest ? .southWest : self == .southWest ? .southEast : self == .southEast ? .northEast : .northWest }
}
