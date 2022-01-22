//
//  FoliageExportOperation.swift
//
//  Created by Zack Brown on 31/10/2021.
//

import Foundation
import Harvest
import Meadow
import PeakOperation

class FoliageExportOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<([SurfaceTilesetTile], [String : FileWrapper]), Error> = Result { throw ResultError.noResult }
    
    override func execute() {
        
        var prototypes: [PrototypeFoliage] = []
        
        prototypes.append(PrototypeBamboo(footprint: .x1))
        
        prototypes.append(PrototypeGingko(footprint: .x1))
        
        prototypes.append(PrototypeCherryBlossom(footprint: .x1))
        
        let exportOperation = PrototypeTileExportOperation(prototypes: prototypes)
        
        let group = DispatchGroup()
        
        group.enter()
        
        exportOperation.enqueue(on: internalQueue) { [weak self] result in
            
            guard let self = self else { return }
            
            self.output = result
            
            group.leave()
        }
        
        group.wait()
        
        finish()
    }
}
