//
//  BuildingCorner.swift
//
//  Created by Zack Brown on 29/07/2021.
//

import Euclid
import Foundation
import Meadow

struct BuildingCorner: Prop {
    
    enum Constants {
        
        static let inset = 0.03
    }
    
    let style: Building.Architecture.MasonryStyle
    
    let o0: Ordinal
    let o1: Ordinal
    let c0: Cardinal
    let c1: Cardinal
    
    let height: Double
    
    let textureCoordinates: UVs
    
    func build(position: Vector) -> [Euclid.Polygon] {
        
        let n0 = Vector(Double(c0.normal.x), Double(c0.normal.y), Double(c0.normal.z))
        let n1 = Vector(Double(c1.normal.x), Double(c1.normal.y), Double(c1.normal.z))
        let no0 = (n0 + n1).normalized()
        let no1 = (n0 + -n1).normalized()
        
        let diagonalInset = sqrt((Constants.inset * Constants.inset) * 2.0)
        var v0 = (no0 * diagonalInset)
        var v1 = Vector.zero
        var v2 = Vector.zero
        var v3 = Vector.zero
        var v4 = Vector.zero
        
        switch style {
            
        case .pillar(let angled),
                .quoins(let angled, _):
            
            if angled {
                
                if o1 == o0.next {
                    
                    v2 = (no1 * diagonalInset)
                    v1 = v2 + (no0 * diagonalInset)
                    v3 = (-n0 * Constants.inset)
                    v4 = v3 + (n1 * Constants.inset)
                }
                else {
                    
                    v2 = (-n0 * Constants.inset)
                    v1 = v2 + (n1 * Constants.inset)
                    v3 = (no1 * diagonalInset)
                    v4 = v3 + (no0 * diagonalInset)
                }
            }
            else {
                
                v2 = (-n0 * Constants.inset)
                v1 = v2 + (n1 * Constants.inset)
                v3 = (-n1 * Constants.inset)
                v4 = v3 + (n0 * Constants.inset)
            }
            
        default: break
        }
        
        var polygons: [Euclid.Polygon] = []
        
        switch style {
            
        case .pillar:
            
            let y = Vector(0, height, 0)
            
            v0 += position
            v1 += position
            v2 += position
            v3 += position
            v4 += position
            
            guard let p0 = polygon(vectors: [v1, v0, v0 + y, v1 + y], uvs: textureCoordinates.corners),
                  let p1 = polygon(vectors: [v2, v1, v1 + y, v2 + y], uvs: textureCoordinates.corners),
                  let p2 = polygon(vectors: [position, v2, v2 + y, position + y], uvs: textureCoordinates.corners),
                  let p3 = polygon(vectors: [v3, position, position + y, v3 + y], uvs: textureCoordinates.corners),
                  let p4 = polygon(vectors: [v4, v3, v3 + y, v4 + y], uvs: textureCoordinates.corners),
                  let p5 = polygon(vectors: [v0, v4, v4 + y, v0 + y], uvs: textureCoordinates.corners),
                  let ulhs = polygon(vectors: [position + y, v2 + y, v1 + y, v0 + y], uvs: textureCoordinates.corners),
                  let urhs = polygon(vectors: [v4 + y, v3 + y, position + y, v0 + y], uvs: textureCoordinates.corners),
                  let llhs = polygon(vectors: [v0, v1, v2, position], uvs: textureCoordinates.corners),
                  let lrhs = polygon(vectors: [v0, position, v3, v4], uvs: textureCoordinates.corners) else { return polygons }
            
            polygons.append(contentsOf: [ulhs, urhs, llhs, lrhs, p0, p1, p2, p3, p4, p5])
            
        case .quoins(let angled, let layers):
            
            let brickHeight = (height / Double(layers))
            let v6 = Vector.zero.lerp(v2, 0.5)
            let v7 = Vector.zero.lerp(v3, 0.5)
            var v5 = Vector.zero
            var v8 = Vector.zero
            
            if angled {
                
                if o1 == o0.next {
                    
                    v5 = v6 + (no0 * diagonalInset)
                    v8 = v7 + (n1 * Constants.inset)
                }
                else {
                    
                    v5 = v6 + (n1 * Constants.inset)
                    v8 = v7 + (no0 * diagonalInset)
                }
            }
            else {
                
                v5 = v6 + (n1 * Constants.inset)
                v8 = v7 + (n0 * Constants.inset)
            }
            
            for layer in 0..<layers {
                
                let y0 = Vector(position.x, position.y + (brickHeight * Double(layer)), position.z)
                let y1 = Vector(position.x, position.y + (brickHeight * Double(layer + 1)), position.z)
                
                if layer % 2 == 0 {
                    
                    guard let p0 = polygon(vectors: [v1 + y0, v0 + y0, v0 + y1, v1 + y1], uvs: textureCoordinates.corners),
                          let p1 = polygon(vectors: [v2 + y0, v1 + y0, v1 + y1, v2 + y1], uvs: textureCoordinates.corners),
                          let p2 = polygon(vectors: [y0, v2 + y0, v2 + y1, y1], uvs: textureCoordinates.corners),
                          let p3 = polygon(vectors: [v7 + y0, y0, y1, v7 + y1], uvs: textureCoordinates.corners),
                          let p4 = polygon(vectors: [v8 + y0, v7 + y0, v7 + y1, v8 + y1], uvs: textureCoordinates.corners),
                          let p5 = polygon(vectors: [v0 + y0, v8 + y0, v8 + y1, v0 + y1], uvs: textureCoordinates.corners),
                          let ulhs = polygon(vectors: [y1, v2 + y1, v1 + y1, v0 + y1], uvs: textureCoordinates.corners),
                          let urhs = polygon(vectors: [v8 + y1, v7 + y1, y1, v0 + y1], uvs: textureCoordinates.corners),
                          let llhs = polygon(vectors: [v0 + y0, v1 + y0, v2 + y0, y0], uvs: textureCoordinates.corners),
                          let lrhs = polygon(vectors: [v0 + y0, y0, v7 + y0, v8 + y0], uvs: textureCoordinates.corners) else { return polygons }
                    
                    polygons.append(contentsOf: [ulhs, urhs, llhs, lrhs, p0, p1, p2, p3, p4, p5])
                }
                else {
                    
                    guard let p0 = polygon(vectors: [v5 + y0, v0 + y0, v0 + y1, v5 + y1], uvs: textureCoordinates.corners),
                          let p1 = polygon(vectors: [v6 + y0, v5 + y0, v5 + y1, v6 + y1], uvs: textureCoordinates.corners),
                          let p2 = polygon(vectors: [y0, v6 + y0, v6 + y1, y1], uvs: textureCoordinates.corners),
                          let p3 = polygon(vectors: [v3 + y0, y0, y1, v3 + y1], uvs: textureCoordinates.corners),
                          let p4 = polygon(vectors: [v4 + y0, v3 + y0, v3 + y1, v4 + y1], uvs: textureCoordinates.corners),
                          let p5 = polygon(vectors: [v0 + y0, v4 + y0, v4 + y1, v0 + y1], uvs: textureCoordinates.corners),
                          let ulhs = polygon(vectors: [y1, v6 + y1, v5 + y1, v0 + y1], uvs: textureCoordinates.corners),
                          let urhs = polygon(vectors: [v4 + y1, v3 + y1, y1, v0 + y1], uvs: textureCoordinates.corners),
                          let llhs = polygon(vectors: [v0 + y0, v5 + y0, v6 + y0, y0], uvs: textureCoordinates.corners),
                          let lrhs = polygon(vectors: [v0 + y0, y0, v3 + y0, v4 + y0], uvs: textureCoordinates.corners) else { return polygons }
                    
                    polygons.append(contentsOf: [ulhs, urhs, llhs, lrhs, p0, p1, p2, p3, p4, p5])
                }
            }
            
        default: break
        }
        
        return polygons
    }
}
