//
//  GroupNode.swift
//
//  Created by Zack Brown on 05/04/2021.
//

import Euclid
import Foundation
import Meadow
import SceneKit

@objc protocol SceneGraphNode: class {
    
    var identifier: String { get }
    var children: [GroupNode] { get }
    var childCount: Int { get }
    var isLeaf: Bool { get }
    var name: String? { get }
    var image: NSImage? { get }
    var operationIdentifier: String { get }
}

class GroupNode: SCNNode, Codable, Hideable, SceneGraphNode, Soilable, StartOption {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case children
        case operation
        case primitive
        case transform
        case hidden
        case locked
        case mesh
    }
    
    @objc enum Operation: Int, CaseIterable, Codable {
        
        case intersect
        case stencil
        case subtract
        case union
        case xor
        
        public var abbreviation: String {
            
            switch self {
            
            case .intersect: return "I"
            case .stencil: return "St"
            case .subtract: return "-"
            case .union: return "+"
            case .xor: return "X"
            }
        }
        
        public var description: String {
            
            switch self {
            
            case .intersect: return "Intersect"
            case .stencil: return "Stencil"
            case .subtract: return "Subtract"
            case .union: return "Union"
            case .xor: return "XOR"
            }
        }
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
        
    public var isDirty: Bool = false
    
    public var identifier: String
    public var children: [GroupNode] = []
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var image: NSImage? { isLeaf ? NSImage(named: "chunk_icon") : NSImage(named: "prop_icon") }
    public var operationIdentifier: String { operation.abbreviation }
    
    var operation: Operation = .union {
        
        didSet {
            
            if oldValue != operation {
                
                becomeDirty()
            }
        }
    }
    
    var groupTransform: Euclid.Transform = .identity {
        
        didSet {
            
            if oldValue != groupTransform {
                
                becomeDirty()
            }
        }
    }
    
    override var isHidden: Bool {
        
        didSet {
            
            if oldValue != isHidden {
                
                becomeDirty()
            }
        }
    }
    
    var isLocked: Bool = true {
        
        didSet {
            
            if oldValue != isLocked {
                
                becomeDirty()
            }
        }
    }
    
    var isSelected: Bool = false {
        
        didSet {
            
            if oldValue != isSelected {
                
                becomeDirty()
            }
        }
    }
    
    var mesh: Euclid.Mesh?
    
    var primitive: Primitive? {
        
        didSet {
            
            if oldValue != primitive {
                
                becomeDirty()
            }
        }
    }
    
    init(primitive: Primitive) {
        
        self.primitive = primitive
        identifier = UUID().uuidString
        
        super.init()
        
        name = primitive.rawType.description
        
        becomeDirty()
    }
    
    override init() {
        
        identifier = UUID().uuidString
        
        super.init()
        
        name = "Group"
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
            
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = UUID().uuidString
        children = try container.decode([GroupNode].self, forKey: .children)
        operation = try container.decode(Operation.self, forKey: .operation)
        primitive = try container.decodeIfPresent(Primitive.self, forKey: .primitive)
        groupTransform = try container.decode(Euclid.Transform.self, forKey: .transform)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        isHidden = try container.decode(Bool.self, forKey: .hidden)
        isLocked = try container.decode(Bool.self, forKey: .locked)
        mesh = try container.decodeIfPresent(Mesh.self, forKey: .mesh)
        
        for child in children {
            
            addChildNode(child)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(children, forKey: .children)
        try container.encode(operation, forKey: .operation)
        try container.encodeIfPresent(primitive, forKey: .primitive)
        try container.encode(groupTransform, forKey: .transform)
        try container.encode(name, forKey: .name)
        try container.encode(isHidden, forKey: .hidden)
        try container.encode(isLocked, forKey: .locked)
        try container.encodeIfPresent(mesh, forKey: .mesh)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(groupTransform.offset)
        
        if isLeaf {
            
            if mesh == nil || !isLocked {
            
                print("Shape: Cleaning \(name ?? "")")
                
                mesh = primitive?.mesh
            }
        }
        else {
            
            print("Group: Cleaning \(name ?? "")")
            
            let nodes = children.compactMap { $0.isHidden ? nil : $0 }
        
            for group in nodes {
            
                group.clean()
            }

            mesh = Euclid.Mesh([])

            for group in nodes {
                
                guard let groupMesh = group.mesh?.transformed(by: group.groupTransform) else { continue }

                switch group.operation {

                case .intersect:

                    mesh = mesh?.intersect(groupMesh)

                case .stencil:

                    mesh = mesh?.stencil(groupMesh)

                case .subtract:

                    mesh = mesh?.subtract(groupMesh)

                case .union:

                    mesh = mesh?.union(groupMesh)

                case .xor:

                    mesh = mesh?.xor(groupMesh)
                }
            }
        }
        
        if let mesh = mesh?.transformed(by: groupTransform) {
            
            geometry = ancestor == nil || isSelected ? (ancestor == nil ? SCNGeometry(mesh) : SCNGeometry(wireframe: mesh)) : nil
            geometry?.firstMaterial?.diffuse.contents = MDWImage(named: "uvs")
        }
        
        isDirty = false
        
        return true
    }
}

extension GroupNode {
    
    func add(child: GroupNode) {
        
        guard !children.contains(child) else { return }
        
        children.append(child)
        
        addChildNode(child)
        
        becomeDirty()
    }
    
    func add(child: GroupNode, atIndex index: Int) {
        
        guard !children.contains(child),
              child.parent == nil,
              index >= 0,
              index <= childCount else { return }
        
        children.insert(child, at: index)
        
        addChildNode(child)
        
        becomeDirty()
    }
    
    func find(child identifier: String) -> GroupNode? {
        
        guard self.identifier != identifier else { return self }
        
        for child in children {
            
            if let node = child.find(child: identifier) {
                
                return node
            }
        }
        
        return nil
    }
    
    func remove(child: GroupNode) {
        
        guard let index = children.firstIndex(of: child) else { return }
        
        children.remove(at: index)
        
        child.removeFromParentNode()
        
        becomeDirty()
    }
}

extension GroupNode {
    
    func select(node: GroupNode) {
        
        isSelected = node == self
        
        for child in children {
            
            child.select(node: node)
        }
    }
}
