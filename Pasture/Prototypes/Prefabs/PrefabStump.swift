//
//  PrefabTreeStump.swift
//
//  Created by Zack Brown on 17/01/2022.
//

import Euclid
import Meadow

struct PrefabStump: Prefab {
    
    enum Constants {
        
        static let ratio = Math.golden / 2.0
    }
    
    enum Shape: Prefab {
        
        case sapling
        case tree
        
        var colorPalette: ColorPalette { .stump }
        
        func mesh(position: Vector, size: Vector) -> Mesh {
            
            let peak = position + Vector(x: 0, y: size.y, z: 0)
            
            let base = SurfaceGrid(position: position, radius: size.x)
            let apex = SurfaceGrid(position: peak, radius: size.x * Constants.ratio)
            
            var lower: [PathPoint] = []
            var upper: [PathPoint] = []
            
            for cardinal in Cardinal.allCases {
                
                let (o0, o1) = cardinal.ordinals
            
                let bc0 = base.corner(ordinal: o0)
                let bc1 = base.corner(ordinal: o1)
                var be0 = base.edge(cardinal: cardinal)
                let bm0 = be0.lerp(base.center, Constants.ratio / 2.0)
                
                let ac0 = apex.corner(ordinal: o0)
                let ac1 = apex.corner(ordinal: o1)
                var ae0 = apex.edge(cardinal: cardinal)
                let am0 = ae0.lerp(apex.center, Constants.ratio / 2.0)
                
                var bi0 = bc0
                var bi1 = bc1
                
                var ai0 = ac0
                var ai1 = ac1
                
                switch self {
                    
                case .sapling:
                    
                    be0 = bm0
                    bi0 = bi0.lerp(bc1, Constants.ratio / 2.0)
                    bi1 = bi1.lerp(bc0, Constants.ratio / 2.0)
                    
                    ae0 = am0
                    ai0 = ai0.lerp(ac1, Constants.ratio / 2.0)
                    ai1 = ai1.lerp(ac0, Constants.ratio / 2.0)
                    
                case .tree:
                    
                    bi0 = bi0.lerp(bm0, Constants.ratio)
                    bi1 = bi1.lerp(bm0, Constants.ratio)
                    
                    ai0 = ai0.lerp(am0, Constants.ratio)
                    ai1 = ai1.lerp(am0, Constants.ratio)
                }
                
                let bv = [bc0, bi0, be0, bi1, bc1]
                let av = [ac0, ai0, ae0, ai1, ac1]
                
                let bp = bv.map { PathPoint($0, texcoord: nil, color: colorPalette.tertiary, isCurved: false) }
                let ap = av.map { PathPoint($0, texcoord: nil, color: colorPalette.quaternary, isCurved: false) }
                
                lower.append(contentsOf: bp)
                upper.append(contentsOf: ap)
            }
            
            let lp = Path(lower)
            let up = Path(upper)
            
            return Mesh.loft([lp, up], faces: .front)
        }
    }
    
    let shape: Shape
    
    func mesh(position: Vector, size: Vector) -> Mesh { shape.mesh(position: position, size: size) }
}
