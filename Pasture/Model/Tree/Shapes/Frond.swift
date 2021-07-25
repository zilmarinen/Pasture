//
//  Frond.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import Euclid
import Foundation
import GameKit
import Meadow

struct Frond: Prop {
    
    let plane: Euclid.Plane
    let noise: Noise
    
    let angle: Double
    let radius: Double
    let width: Double
    let thickness: Double
    let spread: Double
    
    let segments: Int
    
    let textureCoordinates: UVs

    func build(position: Euclid.Vector) -> [Euclid.Polygon] {
            
        let step = Double(1.0 / Double(segments))
        let uvStep = (textureCoordinates.end.y - textureCoordinates.start.y) / Double(segments)
        
        let anchor = plot(radians: angle, radius: radius)
        let control = position + anchor.project(onto: plane)
        let end = control + (-plane.normal * radius)
        let middle = curve(start: position, end: end, control: control, interpolator: 0.5)
        let perpendicular = [position, middle, end].normal()
        var length = Math.ease(curve: .out, value: step) * width
        
        let size = Vector(Double(segments), 0, Double(segments))
        let sampleCount = Vector(2, 0, Double(segments))
        
        let map = noise.map(size: size, sampleCount: sampleCount, origin: end)
        
        var polygons: [Euclid.Polygon] = []
        
        var sweep = (lhs: position + (-perpendicular * (length / 2.0)),
                     curve: position,
                     rhs: position + (perpendicular * (length / 2.0)))
        
        for segment in 1..<segments {

            let interpolator = step * Double(segment)

            let uvy0 = textureCoordinates.start.x + (uvStep * Double(segment))
            let uvy1 = textureCoordinates.start.x + (uvStep * Double(segment + 1))

            let uv0 = Euclid.Vector(textureCoordinates.end.x, uvy0)
            let uv1 = Euclid.Vector(textureCoordinates.start.x, uvy0)
            let uv2 = Euclid.Vector(textureCoordinates.start.x, uvy1)
            let uv3 = Euclid.Vector(textureCoordinates.end.x, uvy1)

            let peakUV = uv0.lerp(uv1, 0.5)
            let baseUV = uv3.lerp(uv2, 0.5)

            let point = curve(start: position, end: end, control: control, interpolator: interpolator)

            length = Math.ease(curve: .out, value: interpolator) * width

            let current = (lhs: (point + (-perpendicular * length)),
                           curve: point,
                           rhs: (point + (perpendicular * length)))
            
            let lhs = (vertices: [sweep.curve, sweep.lhs, current.lhs, current.curve], uvs: [uv1, peakUV, baseUV, uv2])
            let rhs = (vertices: [sweep.rhs, sweep.curve, current.curve, current.rhs], uvs: [peakUV, uv0, uv3, baseUV])
            
            let s0 = Double(map.value(at: vector2(0, Int32(segment))))
            let s1 = Double(map.value(at: vector2(1, Int32(segment))))
            
            polygons.append(contentsOf: face(vertices: lhs.vertices, uvs: lhs.uvs, side: .left, cut: s0 > 0))
            polygons.append(contentsOf: face(vertices: rhs.vertices, uvs: rhs.uvs, side: .right, cut: s1 > 0))
            
            if segment == 1 {
                
                let n0 = lhs.vertices.normal()
                let n1 = rhs.vertices.normal()
                
                let v0 = sweep.lhs - (n0 * thickness)
                let v1 = sweep.rhs - (n1 * thickness)
                let v2 = v0.lerp(v1, 0.5)
                
                guard let lf0 = polygon(vectors: [sweep.lhs, sweep.curve, v2], uvs: [lhs.uvs[0], lhs.uvs[1], lhs.uvs[2]]),
                      let lf1 = polygon(vectors: [sweep.lhs, v2, v0], uvs: [lhs.uvs[0], lhs.uvs[2], lhs.uvs[3]]),
                      let rf0 = polygon(vectors: [sweep.curve, sweep.rhs, v1], uvs: [rhs.uvs[0], rhs.uvs[1], rhs.uvs[2]]),
                      let rf1 = polygon(vectors: [sweep.curve, v1, v2], uvs: [rhs.uvs[0], rhs.uvs[2], rhs.uvs[3]]) else { continue }
                
                polygons.append(contentsOf: [lf0, lf1, rf0, rf1])
            }

            sweep = current
        }
        
        let uvy0 = textureCoordinates.start.x + (uvStep * Double(segments - 1))
        let uvy1 = textureCoordinates.start.x + (uvStep * Double(segments))

        let uv0 = Euclid.Vector(textureCoordinates.end.x, uvy0)
        let uv1 = Euclid.Vector(textureCoordinates.start.x, uvy0)
        let uv2 = Euclid.Vector(textureCoordinates.start.x, uvy1)
        let uv3 = Euclid.Vector(textureCoordinates.end.x, uvy1)

        let baseUV = uv3.lerp(uv2, 0.5)

        let upperFace = [sweep.rhs, sweep.lhs, end]
        let normal = upperFace.normal()
        let lowerFace = [end, sweep.lhs, sweep.rhs].map{ $0 - (normal * thickness) }
        let leftFace = [upperFace[2], upperFace[1], lowerFace[1], lowerFace[0]]
        let rightFace = [upperFace[0], upperFace[2], lowerFace[0], lowerFace[2]]
        let uvs = [uv1, uv0, baseUV]
        
        guard let upperPolygon = self.polygon(vectors: upperFace, uvs: uvs),
              let lowerPolygon = self.polygon(vectors: lowerFace, uvs: uvs),
              let lp0 = self.polygon(vectors: [leftFace[0], leftFace[1], leftFace[2]], uvs: [uv0, uv1, uv2]),
              let lp1 = self.polygon(vectors: [leftFace[0], leftFace[2], leftFace[3]], uvs: [uv0, uv2, uv3]),
              let rp0 = self.polygon(vectors: [rightFace[0], rightFace[1], rightFace[2]], uvs: [uv0, uv1, uv2]),
              let rp1 = self.polygon(vectors: [rightFace[0], rightFace[2], rightFace[3]], uvs: [uv0, uv2, uv3])else { return polygons }

        polygons.append(contentsOf: [upperPolygon, lowerPolygon, lp0, lp1, rp0, rp1])
        
        return polygons
    }
}

extension Frond {
    
    enum Side {
        
        case left
        case right
    }
    
    func face(vertices: [Euclid.Vector], uvs: [Euclid.Vector], side: Side, cut: Bool) -> [Euclid.Polygon] {
        
        guard vertices.count == uvs.count else { return [] }
        
        let normal = vertices.normal()
        
        let lowerVertices = vertices.reversed().map { $0 - (normal * thickness) }
        
        let faces = (upper: (vertices: vertices, uvs: uvs, center: vertices.average()),
                     lower: (vertices: lowerVertices, uvs: uvs, center: lowerVertices.average()))
        
        guard cut else {
            
            let edgeVertices = side == .left ? [faces.lower.vertices[2],
                                                faces.lower.vertices[1],
                                                faces.upper.vertices[2],
                                                faces.upper.vertices[1]] :
                                                [faces.upper.vertices[0],
                                                 faces.upper.vertices[3],
                                                 faces.lower.vertices[0],
                                                 faces.lower.vertices[3]]
            
            guard let uf0 = polygon(vectors: [faces.upper.vertices[0], faces.upper.vertices[1], faces.upper.vertices[2]], uvs: [faces.upper.uvs[0], faces.upper.uvs[1], faces.upper.uvs[2]]),
                  let uf1 = polygon(vectors: [faces.upper.vertices[0], faces.upper.vertices[2], faces.upper.vertices[3]], uvs: [faces.upper.uvs[0], faces.upper.uvs[2], faces.upper.uvs[3]]),
                  let lf0 = polygon(vectors: [faces.lower.vertices[0], faces.lower.vertices[1], faces.lower.vertices[2]], uvs: [faces.lower.uvs[0], faces.lower.uvs[1], faces.lower.uvs[2]]),
                  let lf1 = polygon(vectors: [faces.lower.vertices[0], faces.lower.vertices[2], faces.lower.vertices[3]], uvs: [faces.lower.uvs[0], faces.lower.uvs[2], faces.lower.uvs[3]]),
                  let ef0 = polygon(vectors: [edgeVertices[0], edgeVertices[1], edgeVertices[2]], uvs: [faces.upper.uvs[0], faces.upper.uvs[1], faces.upper.uvs[2]]),
                  let ef1 = polygon(vectors: [edgeVertices[0], edgeVertices[2], edgeVertices[3]], uvs: [faces.upper.uvs[0], faces.upper.uvs[2], faces.upper.uvs[3]]) else { return [] }
            
            return [uf0, uf1, lf0, lf1, ef0, ef1]
        }
        
        let v0 = faces.upper.vertices.average()
        let v1 = faces.upper.vertices[1].lerp(faces.upper.vertices[2], 0.5)
        let v2 = faces.upper.vertices[0].lerp(faces.upper.vertices[3], 0.5)
        
        let v3 = v0 - (normal * thickness)
        let v4 = v1 - (normal * thickness)
        let v5 = v2 - (normal * thickness)
        
        let uv0 = faces.upper.uvs.average()
        let uv1 = faces.upper.uvs[1].lerp(faces.upper.uvs[2], 0.5)
        let uv2 = faces.upper.uvs[0].lerp(faces.upper.uvs[3], 0.5)
        
        let topFaces = face(vertices: [faces.upper.vertices[0], faces.upper.vertices[1], v1, v2], uvs: [faces.upper.uvs[0], faces.upper.uvs[1], uv1, uv2], side: side, cut: false)
        switch side {
            
        case .left:
            
            let bottomFaces = face(vertices: [v2, v0, faces.upper.vertices[2], faces.upper.vertices[3]], uvs: [uv2, uv0, faces.upper.uvs[2], faces.upper.uvs[3]], side: side, cut: false)
            
            guard let ef0 = polygon(vectors: [v0, v1, v4], uvs: [faces.upper.uvs[0], faces.upper.uvs[1], faces.upper.uvs[2]]),
                  let ef1 = polygon(vectors: [v0, v4, v3], uvs: [faces.upper.uvs[0], faces.upper.uvs[2], faces.upper.uvs[3]]) else { return topFaces + bottomFaces }
            
            return topFaces + bottomFaces + [ef0, ef1]
            
        case .right:
            
            let bottomFaces = face(vertices: [v0, v1, faces.upper.vertices[2], faces.upper.vertices[3]], uvs: [uv0, uv1, faces.upper.uvs[2], faces.upper.uvs[3]], side: side, cut: false)
            
            guard let ef0 = polygon(vectors: [v2, v0, v3], uvs: [faces.upper.uvs[0], faces.upper.uvs[1], faces.upper.uvs[2]]),
                  let ef1 = polygon(vectors: [v2, v3, v5], uvs: [faces.upper.uvs[0], faces.upper.uvs[2], faces.upper.uvs[3]]) else { return topFaces + bottomFaces }
            
            return topFaces + bottomFaces + [ef0, ef1]
        }
    }
}
