//
//  PrefabCylinder.swift
//
//  Created by Zack Brown on 21/01/2022.
//

import Euclid
import Meadow

struct PrefabCylinder: Prefab {
    
    let normal: Vector
    
    let sides: Int
    
    let colorPalette: ColorPalette
 
    func mesh(position: Vector, size: Vector) -> Mesh {
        
        guard let plane = Plane(normal: normal, pointOnPlane: .zero) else { return Mesh([]) }
        
        let peak = position + (size.y * normal)
        
        let apex = SurfaceGrid(position: peak, radius: size.x)
        let base = SurfaceGrid(position: position, radius: size.x)
        
        let sideStep = 360.0 / Double(sides)
        
        var points: (apex: [PathPoint],
                     base: [PathPoint]) = ([], [])
        
        for side in 0...sides {
            
            let angle = Angle(degrees: Double(side) * sideStep)
            
            let a = apex.center + Math.plot(radians: angle.radians, radius: apex.radius).project(onto: plane)
            let b = base.center + Math.plot(radians: angle.radians, radius: base.radius).project(onto: plane)

            points.apex.append(PathPoint(a, texcoord: nil, color: colorPalette.primary, isCurved: false))
            points.base.append(PathPoint(b, texcoord: nil, color: colorPalette.quaternary, isCurved: false))
        }
        
        let (p0, p1) = (Path(points.apex), Path(points.base))
        
        return Mesh.loft([p0, p1], faces: .front)
    }
}
