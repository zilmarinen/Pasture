//
//  PrefabCanopy.swift
//
//  Created by Zack Brown on 18/01/2022.
//

import Euclid
import Meadow

struct PrefabCanopy: Prefab {
    
    enum Shape {
        
        case quad
        case tri
        case oct
        
        func prefab(with colorPalette: ColorPalette) -> Prefab {
            
            switch self {
                
            case .quad: return Quad(colorPalette: colorPalette)
            case .tri: return Tri(colorPalette: colorPalette)
            case .oct: return Oct(colorPalette: colorPalette)
            }
        }
    }
    
    let shape: Shape
    let colorPalette: ColorPalette
    
    func mesh(position: Vector, size: Vector) -> Mesh { shape.prefab(with: colorPalette).mesh(position: position, size: size) }
}

extension PrefabCanopy {
    
    struct Tri: Prefab {
        
        enum Constants {
            
            static let ratio = Math.golden / 2.0
        }
        
        let colorPalette: ColorPalette
        
        func mesh(position: Vector, size: Vector) -> Mesh {
            
            let peak = position + Vector(x: 0, y: size.y, z: 0)
            
            let (primary, tertiary) = (colorPalette.primary, colorPalette.secondary)
            let secondary = primary.lerp(tertiary, Constants.ratio)
            
            let throne = SurfaceGrid(position: position, radius: size.x / 2.0)
            
            var polygons: [Polygon] = []
            
            for cardinal in Cardinal.allCases {
                
                let (o0, o1) = cardinal.ordinals
                let o2 = o0.opposite
                
                let t0 = throne.edge(o0: o1, o1: o0, interpolator: Constants.ratio)
                let t1 = throne.edge(o0: o0, o1: o1, interpolator: Constants.ratio)
                let t2 = throne.edge(o0: o2, o1: o1, interpolator: Constants.ratio)
                
                let t3 = peak.lerp(throne.corner(ordinal: o0), Constants.ratio)
                let t4 = peak.lerp(throne.corner(ordinal: o1), Constants.ratio)
                
                let faces = [[t3, peak, t4, t1, t0],
                             [t1, t4, t2],
                             [t0, t1, t2, throne.center]]
                
                let colors = [[secondary, primary, secondary, tertiary, tertiary],
                              [tertiary, secondary, tertiary],
                              [tertiary, tertiary, tertiary, tertiary]]
                
                let normals = faces.map { $0.normal() }
                
                for faceIndex in faces.indices {
                    
                    let face = faces[faceIndex]
                    let normal = normals[faceIndex]
                    let faceColors = colors[faceIndex]
                    
                    var vertices: [Vertex] = []
                    
                    for positionIndex in face.indices {
                        
                        let position = face[positionIndex]
                        let color = faceColors[positionIndex]
                        
                        vertices.append(Vertex(position, normal, nil, color))
                    }
                    
                    guard let polygon = Polygon(vertices) else { continue }
                    
                    polygons.append(polygon)
                }
            }
            
            return Mesh(polygons)
        }
    }
}

extension PrefabCanopy {
    
    struct Quad: Prefab {
        
        enum Constants {
            
            static let ratio = Math.golden / 2.0
            
            static let apexRatio = 4.0
            static let crownRatio = 2.5
            static let throneRatio = 2.0
            static let baseRatio = 3.0
        }
        
        let colorPalette: ColorPalette
        
        func mesh(position: Vector, size: Vector) -> Mesh {
            
            let peak = position + Vector(x: 0, y: size.y, z: 0)
            
            let p0 = peak.lerp(position, Constants.ratio)
            let p1 = position.lerp(peak, Constants.ratio)
            
            let (primary, quaternary) = (colorPalette.primary, colorPalette.secondary)
            let secondary = quaternary.lerp(primary, Constants.ratio)
            let tertiary = primary.lerp(quaternary, Constants.ratio)
            
            let apex = SurfaceGrid(position: peak, radius: size.x / Constants.apexRatio)
            let crown = SurfaceGrid(position: p1, radius: size.x / Constants.crownRatio)
            let throne = SurfaceGrid(position: p0, radius: size.x / Constants.throneRatio)
            let base = SurfaceGrid(position: position, radius: size.x / Constants.baseRatio)
            
            var polygons: [Polygon] = []
            
            for cardinal in Cardinal.allCases {
                
                let (o0, o1) = cardinal.ordinals
                
                let b0 = base.corner(ordinal: o0)
                let b1 = base.corner(ordinal: o1)
                
                let t0 = throne.corner(ordinal: o0)
                let t1 = throne.corner(ordinal: o1)
                
                let c0 = crown.corner(ordinal: o0)
                let c1 = crown.corner(ordinal: o1)
                
                let a0 = apex.corner(ordinal: o0)
                let a1 = apex.corner(ordinal: o1)
                
                let faces = [[t0, t1, b1, b0],
                             [c0, c1, t1, t0],
                             [a0, a1, c1, c0],
                             [apex.center, a1, a0],
                             [base.center, b0, b1]]
                
                let colors = [[tertiary, tertiary, quaternary, quaternary],
                              [secondary, secondary, tertiary, tertiary],
                              [primary, primary, secondary, secondary],
                              [primary, primary, primary],
                              [quaternary, quaternary, quaternary]]
                
                let normals = faces.map { $0.normal() }
                
                for faceIndex in faces.indices {
                    
                    let face = faces[faceIndex]
                    let normal = normals[faceIndex]
                    let faceColors = colors[faceIndex]
                    
                    var vertices: [Vertex] = []
                    
                    for positionIndex in face.indices {
                        
                        let position = face[positionIndex]
                        let color = faceColors[positionIndex]
                        
                        vertices.append(Vertex(position, normal, nil, color))
                    }
                    
                    guard let polygon = Polygon(vertices) else { continue }
                    
                    polygons.append(polygon)
                }
            }
            
            return Mesh(polygons)
        }
    }
}

extension PrefabCanopy {
    
    struct Oct: Prefab {
        
        enum Constants {
            
            static let ratio = Math.golden / 2.0
            
            static let apexRatio = 4.0
            static let crownRatio = 2.0
            static let throneRatio = 2.0
            static let baseRatio = 3.0
        }
        
        let colorPalette: ColorPalette
        
        func mesh(position: Vector, size: Vector) -> Mesh {
            
            let peak = position + Vector(x: 0, y: size.y, z: 0)
            
            let p0 = peak.lerp(position, Constants.ratio)
            let p1 = position.lerp(peak, Constants.ratio)
            
            let (primary, quaternary) = (colorPalette.primary, colorPalette.secondary)
            let secondary = quaternary.lerp(primary, Constants.ratio)
            let tertiary = primary.lerp(quaternary, Constants.ratio)
            
            let apex = SurfaceGrid(position: peak, radius: size.x / Constants.apexRatio)
            let crown = SurfaceGrid(position: p1, radius: size.x / Constants.crownRatio)
            let throne = SurfaceGrid(position: p0, radius: size.x / Constants.throneRatio)
            let base = SurfaceGrid(position: position, radius: size.x / Constants.baseRatio)
            
            var polygons: [Polygon] = []
            
            for cardinal in Cardinal.allCases {
                
                let (o0, o1) = cardinal.ordinals
                let o2 = o0.opposite
                
                let b0 = base.corner(ordinal: o0)
                let b1 = base.corner(ordinal: o1)
                
                let t0 = throne.edge(o0: o1, o1: o0, interpolator: Constants.ratio)
                let t1 = throne.edge(o0: o0, o1: o1, interpolator: Constants.ratio)
                let t2 = throne.edge(o0: o2, o1: o1, interpolator: Constants.ratio)
                
                let c0 = crown.edge(o0: o1, o1: o0, interpolator: Constants.ratio)
                let c1 = crown.edge(o0: o0, o1: o1, interpolator: Constants.ratio)
                let c2 = crown.edge(o0: o2, o1: o1, interpolator: Constants.ratio)
                
                let a0 = apex.corner(ordinal: o0)
                let a1 = apex.corner(ordinal: o1)
                
                let faces = [[a0, a1, c1, c0],
                             [c0, c1, t1, t0],
                             [t0, t1, b1, b0],
                             [c1, c2, t2, t1],
                             [a1, c2, c1],
                             [t1, t2, b1],
                             [apex.center, a1, a0],
                             [base.center, b0, b1]]
                
                let colors = [[primary, primary, secondary, secondary],
                              [secondary, secondary, tertiary, tertiary],
                              [tertiary, tertiary, quaternary, quaternary],
                              [secondary, secondary, tertiary, tertiary],
                              [primary, secondary, secondary],
                              [tertiary, tertiary, quaternary],
                              [primary, primary, primary],
                              [quaternary, quaternary, quaternary]]
                
                let normals = faces.map { $0.normal() }
                
                for faceIndex in faces.indices {
                    
                    let face = faces[faceIndex]
                    let normal = normals[faceIndex]
                    let faceColors = colors[faceIndex]
                    
                    var vertices: [Vertex] = []
                    
                    for positionIndex in face.indices {
                        
                        let position = face[positionIndex]
                        let color = faceColors[positionIndex]
                        
                        vertices.append(Vertex(position, normal, nil, color))
                    }
                    
                    guard let polygon = Polygon(vertices) else { continue }
                    
                    polygons.append(polygon)
                }
            }
            
            return Mesh(polygons)
        }
    }
}
