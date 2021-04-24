//
//  GroupInspectorViewController.swift
//
//  Created by Zack Brown on 14/04/2021.
//

import Cocoa
import Euclid

class GroupInspectorViewController: NSViewController {
    
    enum Segment: Int {
        
        case previous
        case label
        case next
    }
    
    @IBOutlet weak var groupBox: NSBox!
    @IBOutlet weak var transformBox: NSBox!
    @IBOutlet weak var polygonsBox: NSBox!
    
    @IBOutlet weak var circleBox: NSBox!
    @IBOutlet weak var quadBox: NSBox!
    
    @IBOutlet weak var coneBox: NSBox!
    @IBOutlet weak var cubeBox: NSBox!
    @IBOutlet weak var cylinderBox: NSBox!
    @IBOutlet weak var sphereBox: NSBox!
    
    @IBOutlet weak var childCountLabel: NSTextField!
    
    @IBOutlet weak var renderingButton: NSButton!
    
    @IBOutlet weak var coneLockedButton: NSButton!
    @IBOutlet weak var cubeLockedButton: NSButton!
    @IBOutlet weak var cylinderLockedButton: NSButton!
    @IBOutlet weak var sphereLockedButton: NSButton!
    @IBOutlet weak var circleLockedButton: NSButton!
    @IBOutlet weak var quadLockedButton: NSButton!
    
    @IBOutlet weak var polygonSegmentedControl: NSSegmentedControl!
    @IBOutlet weak var vertexSegmentedControl: NSSegmentedControl!
    
    @IBOutlet var polygonMenu: NSMenu!
    @IBOutlet var vertexMenu: NSMenu!
    
    @IBOutlet weak var nameTextField: NSTextField! {
        
        didSet {
            
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var operationPopUp: NSPopUpButton! {
        
        didSet {
            
            operationPopUp.removeAllItems()
            
            for option in GroupNode.Operation.allCases {
                
                operationPopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var positionView: VectorView! {
        
        didSet {
            
            positionView.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.vectorView(view)
            }
        }
    }
    
    @IBOutlet weak var rotationView: VectorView! {
        
        didSet {
            
            rotationView.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.vectorView(view)
            }
        }
    }
    
    @IBOutlet weak var scaleView: VectorView! {
        
        didSet {
            
            scaleView.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.vectorView(view)
            }
        }
    }
    
    @IBOutlet weak var circleRadiusStepper: NumberStepper! {
        
        didSet {
            
            circleRadiusStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var circleSlicesStepper: NumberStepper! {
        
        didSet {
            
            circleSlicesStepper.stepper.increment = 1
            
            circleSlicesStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var quadWidthStepper: NumberStepper! {
        
        didSet {
            
            quadWidthStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var quadHeightStepper: NumberStepper! {
        
        didSet {
            
            quadHeightStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var coneRadiusStepper: NumberStepper! {
        
        didSet {
            
            coneRadiusStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var coneHeightStepper: NumberStepper! {
        
        didSet {
            
            coneHeightStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var coneSlicesStepper: NumberStepper! {
        
        didSet {
            
            coneSlicesStepper.stepper.increment = 1
            
            coneSlicesStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var conePoleDetailStepper: NumberStepper! {
        
        didSet {
            
            conePoleDetailStepper.stepper.increment = 1
            
            conePoleDetailStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var cubeSizeVectorView: VectorView! {
        
        didSet {
            
            cubeSizeVectorView.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.vectorView(view)
            }
        }
    }
    
    @IBOutlet weak var cylinderRadiusStepper: NumberStepper! {
        
        didSet {
            
            cylinderRadiusStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var cylinderHeightStepper: NumberStepper! {
        
        didSet {
            
            cylinderHeightStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var cylinderSlicesStepper: NumberStepper! {
        
        didSet {
            
            cylinderSlicesStepper.stepper.increment = 1
            
            cylinderSlicesStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var cylinderPoleDetailStepper: NumberStepper! {
        
        didSet {
            
            cylinderPoleDetailStepper.stepper.increment = 1
            
            cylinderPoleDetailStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var sphereRadiusStepper: NumberStepper! {
        
        didSet {
            
            sphereRadiusStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var sphereSlicesStepper: NumberStepper! {
        
        didSet {
            
            sphereSlicesStepper.stepper.increment = 1
            
            sphereSlicesStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var sphereStacksStepper: NumberStepper! {
        
        didSet {
            
            sphereStacksStepper.stepper.increment = 1
            
            sphereStacksStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var spherePoleDetailStepper: NumberStepper! {
        
        didSet {
            
            spherePoleDetailStepper.stepper.increment = 1
            
            spherePoleDetailStepper.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(view)
            }
        }
    }
    
    @IBOutlet weak var vertexPositionView: VectorView! {
        
        didSet {
            
            vertexPositionView.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.vectorView(view)
            }
        }
    }
    
    @IBOutlet weak var vertexNormalView: VectorView! {
        
        didSet {
            
            vertexNormalView.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.vectorView(view)
            }
        }
    }
    
    @IBOutlet weak var vertexUVsView: VectorView! {
        
        didSet {
            
            vertexUVsView.zStepper.isHidden = true
            
            vertexUVsView.valueDidChange = { [weak self] (view, _) in
                
                guard let self = self else { return }
                
                self.coordinator?.vectorView(view)
            }
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        coordinator?.button(sender)
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        coordinator?.popUp(sender)
    }
    
    @IBAction func segmentedControl(_ sender: NSSegmentedControl) {
        
        coordinator?.segmentedControl(sender)
    }
    
    weak var coordinator: GroupInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

extension GroupInspectorViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        
        coordinator?.textField(nameTextField)
    }
}
