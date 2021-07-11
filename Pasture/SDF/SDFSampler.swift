//
//  SDFSampler.swift
//
//  Created by Zack Brown on 25/06/2021.
//

import Euclid
import Foundation

protocol SDFSampler {
    
    func sample(region: Vector) -> Double
}
