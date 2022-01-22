//
//  PrefabBambooChute.swift
//
//  Created by Zack Brown on 19/01/2022.
//

import Euclid
import Meadow

struct PrefabBambooChute: Prefab {
    
    enum Constants {
        
        static let ratio = Math.golden / 2.0
        
        static let divotRatio = 3.5
        static let apexRatio = 3.0
        static let crownRatio = 3.25
        static let throneRatio = 3.5
        static let baseRatio = 3.0
    }
    
    let segments: Int
    let sides: Int
    
    var colorPalette: ColorPalette { .bamboo }
 
    func mesh(position: Vector, size: Vector) -> Mesh {
        
        let offset = Double.random(in: -0.1...0.1, using: &rng)
        var normal = Vector(x: offset, y: 1, z: -offset).normalized()
        
        let peak = position + (size.y * normal)
        let control = position + Vector(x: 0, y: size.y / 2.0, z: 0)
        
        let segmentStep = 1.0 / Double(segments)
        let sideStep = 360.0 / Double(sides)
        
        var slices: [[PathPoint]] = []
        
        for segment in 0..<segments {
            
            let segmentBase = Math.curve(start: position, end: peak, control: control, interpolator: Double(segment) * segmentStep)
            let segmentPeak = Math.curve(start: position, end: peak, control: control, interpolator: Double(segment + 1) * segmentStep)
            
            normal = (segmentPeak - segmentBase).normalized()
            
            let crownPosition = segmentBase.lerp(segmentPeak, Constants.ratio)
            let thronePosition = segmentPeak.lerp(segmentBase, Constants.ratio)
            
            let apex = SurfaceGrid(position: segmentPeak, radius: size.x / Constants.apexRatio)
            let crown = SurfaceGrid(position: crownPosition, radius: size.x / Constants.crownRatio)
            let throne = SurfaceGrid(position: thronePosition, radius: size.x / Constants.throneRatio)
            let base = SurfaceGrid(position: segmentBase, radius: size.x / Constants.baseRatio)
            
            guard let plane = Plane(normal: normal, pointOnPlane: position) else { continue }
            
            var points: (apex: [PathPoint],
                         crown: [PathPoint],
                         throne: [PathPoint],
                         base: [PathPoint]) = ([], [], [], [])
            
            for side in 0...sides {
                
                let angle = Angle(degrees: Double(side) * sideStep)
                
                let a = apex.center + Math.plot(radians: angle.radians, radius: apex.radius).project(onto: plane)
                let c = crown.center + Math.plot(radians: angle.radians, radius: crown.radius).project(onto: plane)
                let t = throne.center + Math.plot(radians: angle.radians, radius: throne.radius).project(onto: plane)
                let b = base.center + Math.plot(radians: angle.radians, radius: base.radius).project(onto: plane)

                points.apex.append(PathPoint(a, texcoord: nil, color: colorPalette.primary, isCurved: false))
                points.crown.append(PathPoint(c, texcoord: nil, color: colorPalette.tertiary, isCurved: false))
                points.throne.append(PathPoint(t, texcoord: nil, color: colorPalette.secondary, isCurved: false))
                points.base.append(PathPoint(b, texcoord: nil, color: colorPalette.quaternary, isCurved: false))
            }
            
            slices.append(contentsOf: [points.base, points.throne, points.crown])
            
            guard segment == (segments - 1) else { continue }
            
            slices.append(points.apex)
        }
        
        let paths = slices.map { Path($0) }
        
        let chute = Mesh.loft(paths, faces: .front)
        
        let divotSize = (size.x / Constants.divotRatio) * 2.0
        let divotPosition = peak - (divotSize * normal)
        
        let divot = PrefabCylinder(normal: normal, sides: sides, colorPalette: colorPalette)
        
        return chute.union(divot.mesh(position: divotPosition, size: Vector(x: divotSize, y: divotSize, z: divotSize)))
    }
}
