//
//  GroupInspectorCoordinator.swift
//
//  Created by Zack Brown on 14/04/2021.
//

import Cocoa
import Euclid

class GroupInspectorCoordinator: Coordinator<GroupInspectorViewController> {
    
    lazy var viewModel: GroupInspectorViewModel = {
       
        return GroupInspectorViewModel(initialState: .empty)
    }()
    
    override init(controller: GroupInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let option = option as? ViewState else { fatalError("Invalid start option") }
        
        viewModel.state = option
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        viewModel.state = .empty
        
        super.stop(then: completion)
    }
}

extension GroupInspectorCoordinator {
    
    func button(_ sender: NSButton) {
        
        switch viewModel.state {
        
        case .inspector(let node, _, _):
            
            switch sender {
            
            case controller.renderingButton:
             
                node.isHidden = sender.state == .off
                
            case controller.coneLockedButton,
                 controller.cubeLockedButton,
                 controller.cylinderLockedButton,
                 controller.sphereLockedButton,
                 controller.circleLockedButton,
                 controller.quadLockedButton:
                
                node.isLocked = sender.state == .on
                
                focus(node: node)
            
            default: break
            }
            
        default: break
        }
    }
    
    @objc func menuItem(_ sender: NSMenuItem) {
        
        guard let menu = sender.menu else { return }
        
        switch viewModel.state {
        
        case .inspector(let node, var polygonIndex, _):
            
            guard let mesh = node.mesh else { return }
            
            switch menu {
            
            case controller.polygonMenu:
                
                polygonIndex = min(mesh.polygons.count - 1, max(0, sender.tag))
                
                viewModel.state = .inspector(node: node, polygonIndex: polygonIndex, vertexIndex: 0)
                
            case controller.vertexMenu:
                
                let polygon = mesh.polygons[polygonIndex]
                
                let vertexIndex = min(polygon.vertices.count - 1, max(0, sender.tag))
                
                viewModel.state = .inspector(node: node, polygonIndex: polygonIndex, vertexIndex: vertexIndex)
                
            default: break
            }
            
        default: break
        }
    }
    
    func numberStepper(_ sender: NumberStepper) {
        
        switch viewModel.state {
        
        case .inspector(let node, _, _):
            
            switch sender {
            
            case controller.circleRadiusStepper,
                 controller.circleSlicesStepper:
                
                node.primitive = .circle(radius: controller.circleRadiusStepper.doubleValue,
                                         slices: controller.circleSlicesStepper.integerValue)
                
            case controller.quadWidthStepper,
                 controller.quadHeightStepper:
                
                node.primitive = .quad(width: controller.quadWidthStepper.doubleValue,
                                       height: controller.quadHeightStepper.doubleValue)
                
            case controller.coneRadiusStepper,
                 controller.coneHeightStepper,
                 controller.coneSlicesStepper,
                 controller.conePoleDetailStepper:
                
                node.primitive = .cone(radius: controller.coneRadiusStepper.doubleValue,
                                       height: controller.coneHeightStepper.doubleValue,
                                       slices: controller.coneSlicesStepper.integerValue,
                                       poleDetail: controller.conePoleDetailStepper.integerValue)
                
            case controller.cylinderRadiusStepper,
                 controller.cylinderHeightStepper,
                 controller.cylinderSlicesStepper,
                 controller.cylinderPoleDetailStepper:
                
                node.primitive = .cylinder(radius: controller.cylinderRadiusStepper.doubleValue,
                                           height: controller.cylinderHeightStepper.doubleValue,
                                           slices: controller.cylinderSlicesStepper.integerValue,
                                           poleDetail: controller.cylinderPoleDetailStepper.integerValue)
                
            case controller.sphereRadiusStepper,
                 controller.sphereSlicesStepper,
                 controller.sphereStacksStepper,
                 controller.spherePoleDetailStepper:
                
                node.primitive = .sphere(radius: controller.sphereRadiusStepper.doubleValue,
                                        slices: controller.sphereSlicesStepper.integerValue,
                                        stacks: controller.sphereStacksStepper.integerValue,
                                        poleDetail: controller.cylinderPoleDetailStepper.integerValue)
            
            default: break
            }
            
        default: break
        }
    }
    
    func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
        
        case .inspector(let node, _, _):
            
            guard let operation = GroupNode.Operation(rawValue: sender.indexOfSelectedItem) else { return }
            
            node.operation = operation
            
        default: break
        }
    }
    
    func segmentedControl(_ sender: NSSegmentedControl) {
        
        switch viewModel.state {
        
        case .inspector(let node, var polygonIndex, var vertexIndex):
            
            guard let segment = GroupInspectorViewController.Segment(rawValue: sender.indexOfSelectedItem),
                  let mesh = node.mesh else { return }
            
            switch segment {
            
            case .previous:
                
                switch sender {
                
                case controller.polygonSegmentedControl:
                    
                    polygonIndex = max(0, polygonIndex - 1)
                    vertexIndex = 0
                    
                case controller.vertexSegmentedControl:
                    
                    vertexIndex = max(0, vertexIndex - 1)
                
                default: break
                }
                
            case .next:
                
                switch sender {
                
                case controller.polygonSegmentedControl:
                    
                    polygonIndex = min(mesh.polygons.count - 1, max(0, polygonIndex + 1))
                    vertexIndex = 0
                    
                case controller.vertexSegmentedControl:
                    
                    let polygon = mesh.polygons[polygonIndex]
                    
                    vertexIndex = min(polygon.vertices.count - 1, max(0, vertexIndex + 1))
                
                default: break
                }
                
            case .label:
                
                guard let event = NSApplication.shared.currentEvent else { return }
                
                switch sender {
                
                case controller.polygonSegmentedControl:
                    
                    NSMenu.popUpContextMenu(controller.polygonMenu, with: event, for: sender)
                    
                case controller.vertexSegmentedControl:
                    
                    NSMenu.popUpContextMenu(controller.vertexMenu, with: event, for: sender)
                
                default: break
                }
                
                return
            }
            
            viewModel.state = .inspector(node: node, polygonIndex: polygonIndex, vertexIndex: vertexIndex)
            
        default: break
        }
    }
    
    func textField(_ sender: NSTextField) {
        
        switch viewModel.state {
        
        case .inspector(let node, _, _):
            
            node.name = sender.stringValue
            
        default: break
        }
    }
    
    func vectorView(_ sender: VectorView) {
        
        switch viewModel.state {
        
        case .inspector(let node, let polygonIndex, let vertexIndex):
            
            switch sender {
            
            case controller.positionView:
                
                node.groupTransform.offset = sender.vector
                
            case controller.rotationView:
                
                let pitch = Angle(degrees: sender.vector.x)
                let yaw = Angle(degrees: sender.vector.y)
                let roll = Angle(degrees: sender.vector.z)
                
                node.groupTransform.rotation = Euclid.Rotation(pitch: pitch, yaw: yaw, roll: roll)
                
            case controller.scaleView:
                
                node.groupTransform.scale = sender.vector
                
            case controller.cubeSizeVectorView:
                
                node.primitive = .cube(size: sender.vector)
                
            case controller.vertexUVsView:
                
                guard var polygons = node.mesh?.polygons else { break }
                
                let polygon = polygons[polygonIndex]
                var vertices = polygon.vertices
                
                vertices[vertexIndex].texcoord = controller.vertexUVsView.vector
                
                guard let replacement = Polygon(vertices) else { break }
                
                polygons[polygonIndex] = replacement
                
                node.mesh = Mesh(polygons)
                
                node.becomeDirty()
                
            default: break
            }
            
        default: break
        }
    }
}

extension GroupInspectorCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        refresh()
    }
    
    func refresh() {
        
        guard controller.isViewLoaded else { return }
        
        controller.groupBox.isHidden = true
        controller.transformBox.isHidden = true
        controller.polygonsBox.isHidden = true
        controller.circleBox.isHidden = true
        controller.quadBox.isHidden = true
        controller.coneBox.isHidden = true
        controller.cubeBox.isHidden = true
        controller.cylinderBox.isHidden = true
        controller.sphereBox.isHidden = true
        
        switch viewModel.state {
        
        case .inspector(let node, let polygonIndex, let vertexIndex):
            
            guard let polygon = node.mesh?.polygons[polygonIndex] else { break }
            
            let vertex = polygon.vertices[vertexIndex]
            
            controller.groupBox.isHidden = false
            controller.transformBox.isHidden = false
            controller.polygonsBox.isHidden = false
            
            controller.childCountLabel.integerValue = node.childCount
            controller.renderingButton.state = node.isHidden ? .off : .on
            controller.nameTextField.stringValue = node.name ?? ""
            controller.operationPopUp.selectItem(at: node.operation.rawValue)
            
            controller.positionView.vector = node.groupTransform.offset
            controller.rotationView.vector = Euclid.Vector(node.groupTransform.rotation.pitch.degrees, node.groupTransform.rotation.yaw.degrees, node.groupTransform.rotation.roll.degrees)
            controller.scaleView.vector = node.groupTransform.scale
            
            controller.polygonSegmentedControl.isEnabled = node.isLocked
            controller.polygonSegmentedControl.setLabel("Polygon \(polygonIndex)", forSegment: GroupInspectorViewController.Segment.label.rawValue)
            
            controller.vertexSegmentedControl.isEnabled = node.isLocked
            controller.vertexSegmentedControl.setLabel("Vertex \(vertexIndex)", forSegment: GroupInspectorViewController.Segment.label.rawValue)
            
            controller.vertexPositionView.isEnabled = false
            controller.vertexPositionView.vector = vertex.position
            
            controller.vertexNormalView.isEnabled = false
            controller.vertexNormalView.vector = vertex.normal
            
            controller.vertexUVsView.isEnabled = node.isLocked
            controller.vertexUVsView.vector = vertex.texcoord
            
            controller.polygonMenu.removeAllItems()
            controller.vertexMenu.removeAllItems()
            
            if let mesh = node.mesh {
                
                for index in 0..<mesh.polygons.count {
                    
                    let item = NSMenuItem(title: "Polygon \(index)", action: #selector(menuItem(_:)), keyEquivalent: "")
                    
                    item.target = self
                    item.tag = index
                    
                    controller.polygonMenu.addItem(item)
                }
                
                for index in 0..<polygon.vertices.count {
                    
                    let item = NSMenuItem(title: "Vertex \(index)", action: #selector(menuItem(_:)), keyEquivalent: "")
                    
                    item.target = self
                    item.tag = index
                    
                    controller.vertexMenu.addItem(item)
                }
            }
            
            guard let primitive = node.primitive else { return }
            
            switch primitive {
            
            case .circle(let radius, let slices):
                
                controller.circleBox.isHidden = false
                controller.circleLockedButton.state = node.isLocked ? .on : .off
                
                controller.circleRadiusStepper.isEnabled = !node.isLocked
                controller.circleRadiusStepper.doubleValue = radius
                
                controller.circleSlicesStepper.isEnabled = !node.isLocked
                controller.circleSlicesStepper.integerValue = slices
                
            case .quad(let width, let height):
                
                controller.quadBox.isHidden = false
                controller.quadLockedButton.state = node.isLocked ? .on : .off
                
                controller.quadWidthStepper.isEnabled = !node.isLocked
                controller.quadWidthStepper.doubleValue = width
                
                controller.quadHeightStepper.isEnabled = !node.isLocked
                controller.quadHeightStepper.doubleValue = height
            
            case .cone(let radius, let height, let slices, let poleDetail):
                
                controller.coneBox.isHidden = false
                controller.coneLockedButton.state = node.isLocked ? .on : .off
                
                controller.coneRadiusStepper.isEnabled = !node.isLocked
                controller.coneRadiusStepper.doubleValue = radius
                
                controller.coneHeightStepper.isEnabled = !node.isLocked
                controller.coneHeightStepper.doubleValue = height
                
                controller.coneSlicesStepper.isEnabled = !node.isLocked
                controller.coneSlicesStepper.integerValue = slices
                
                controller.conePoleDetailStepper.isEnabled = !node.isLocked
                controller.conePoleDetailStepper.integerValue = poleDetail
                
            case .cube(let size):
                
                controller.cubeBox.isHidden = false
                controller.cubeLockedButton.state = node.isLocked ? .on : .off
                
                controller.cubeSizeVectorView.isEnabled = !node.isLocked
                controller.cubeSizeVectorView.vector = size
                
            case .cylinder(let radius, let height, let slices, let poleDetail):
                
                controller.cylinderBox.isHidden = false
                controller.cylinderLockedButton.state = node.isLocked ? .on : .off
                
                controller.cylinderRadiusStepper.isEnabled = !node.isLocked
                controller.cylinderRadiusStepper.doubleValue = radius
                
                controller.cylinderHeightStepper.isEnabled = !node.isLocked
                controller.cylinderHeightStepper.doubleValue = height
                
                controller.cylinderSlicesStepper.isEnabled = !node.isLocked
                controller.cylinderSlicesStepper.integerValue = slices
                
                controller.cylinderPoleDetailStepper.isEnabled = !node.isLocked
                controller.cylinderPoleDetailStepper.integerValue = poleDetail
                
            case .sphere(let radius, let slices, let stacks, let poleDetail):
                
                controller.sphereBox.isHidden = false
                controller.sphereLockedButton.state = node.isLocked ? .on : .off
                
                controller.sphereRadiusStepper.isEnabled = !node.isLocked
                controller.sphereRadiusStepper.doubleValue = radius
                
                controller.sphereSlicesStepper.isEnabled = !node.isLocked
                controller.sphereSlicesStepper.integerValue = slices
                
                controller.sphereStacksStepper.isEnabled = !node.isLocked
                controller.sphereStacksStepper.integerValue = stacks
                
                controller.spherePoleDetailStepper.isEnabled = !node.isLocked
                controller.spherePoleDetailStepper.integerValue = poleDetail
            }
            
        default: break
        }
    }
}
