//
//  Frond.swift
//
//  Created by Zack Brown on 18/06/2021.
//

import Euclid
import Foundation
import Meadow

struct Frond: Prop {
    
    let position: Euclid.Vector
    let plane: Euclid.Plane
    
    let angle: Double
    let radius: Double
    let width: Double
    let thickness: Double
    let spread: Double
    
    let segments: Int
    
    let textureCoordinates: UVs

    func build() -> [Euclid.Polygon] {
            
        let step = Double(1.0 / Double(segments))
        let uvStep = (textureCoordinates.end.y - textureCoordinates.start.y) / Double(segments)
        
        let anchor = plot(radians: angle, radius: radius)
        let control = anchor.project(onto: plane) + Vector(0, position.y, 0)
        let end = Vector(anchor.x, position.y - radius, anchor.z)
        let middle = curve(start: position, end: end, control: control, interpolator: 0.5)
        let perpendicular = [position, middle, end].normal()
        var length = Math.ease(curve: .out, value: step) * width
        
        var polygons: [Euclid.Polygon] = []
        
        var sweep = (lhs: position + (-perpendicular * length),
                     curve: position,
                     rhs: position + (perpendicular * length))
        
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
            
            polygons.append(contentsOf: face(vertices: lhs.vertices, uvs: lhs.uvs, side: .left, cut: (segment > 1 ? ((Int(Math.random(minimum: 0, maximum: Double(segments * 2))) < segments)) : false)))
            polygons.append(contentsOf: face(vertices: rhs.vertices, uvs: rhs.uvs, side: .right, cut: (segment > 2 ? ((Int(Math.random(minimum: 0, maximum: Double(segments * 2))) < segments)) : false)))
            
            if segment == 1 {
                
                let n0 = lhs.vertices.normal()
                let n1 = rhs.vertices.normal()
                
                let v0 = sweep.lhs - (n0 * thickness)
                let v1 = sweep.rhs - (n1 * thickness)
                let v2 = v0.lerp(v1, 0.5)
                
                guard let leftFace = polygon(vectors: [sweep.lhs, sweep.curve, v2, v0], uvs: lhs.uvs),
                      let rightFace = polygon(vectors: [sweep.curve, sweep.rhs, v1, v2], uvs: lhs.uvs) else { continue }
                
                polygons.append(contentsOf: [leftFace, rightFace])
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
              let leftPolygon = self.polygon(vectors: leftFace, uvs: [uv0, uv1, uv2, uv3]),
              let rightPolygon = self.polygon(vectors: rightFace, uvs: [uv0, uv1, uv2, uv3]) else { return polygons }

        polygons.append(contentsOf: [upperPolygon, lowerPolygon, leftPolygon, rightPolygon])
        
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
            
            guard let upperFace = polygon(vectors: faces.upper.vertices, uvs: faces.upper.uvs),
                  let lowerFace = polygon(vectors: faces.lower.vertices, uvs: faces.lower.uvs),
                  let edgeFace = polygon(vectors: edgeVertices, uvs: faces.upper.uvs) else { return [] }
            
            return [upperFace, lowerFace, edgeFace]
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
            
            guard let edgeFace = polygon(vectors: [v0, v1, v4, v3], uvs: faces.upper.uvs) else { return topFaces + bottomFaces }
            
            return topFaces + bottomFaces + [edgeFace]
            
        case .right:
            
            let bottomFaces = face(vertices: [v0, v1, faces.upper.vertices[2], faces.upper.vertices[3]], uvs: [uv0, uv1, faces.upper.uvs[2], faces.upper.uvs[3]], side: side, cut: false)
            
            guard let edgeFace = polygon(vectors: [v2, v0, v3, v5], uvs: faces.upper.uvs) else { return topFaces + bottomFaces }
            
            return topFaces + bottomFaces + [edgeFace]
        }
    }
}
