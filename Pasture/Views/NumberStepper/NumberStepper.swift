//
//  NumberStepper.swift
//
//  Created by Zack Brown on 08/11/2020.
//

import Cocoa
import Meadow

class NumberStepper: NSView {
    
    var valueDidChange: ((NumberStepper, Double) -> Void)?
    
    let textField = NSTextField()
    let stepper = NSStepper()
    
    var maximumValue: Int {
        
        get {
            
            Int(stepper.maxValue)
        }
        set {
            
            stepper.maxValue = Double(newValue)
        }
    }
    
    var minimumValue: Int {
        
        get {
            
            Int(stepper.minValue)
        }
        set {
            
            stepper.minValue = Double(newValue)
        }
    }
    
    var doubleValue: Double {
        
        get {
            
            stepper.doubleValue
        }
        set {
            
            textField.doubleValue = newValue
            stepper.doubleValue = newValue
        }
    }
    
    var integerValue: Int {
        
        get {
            
            stepper.integerValue
        }
        set {
            
            textField.integerValue = newValue
            stepper.integerValue = newValue
        }
    }
    
    var isEnabled: Bool {
        
        get {
            
            stepper.isEnabled
        }
        set {
            
            textField.isEnabled = newValue
            stepper.isEnabled = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        textField.delegate = self
        textField.controlSize = .small
        textField.doubleValue = 0.0
        
        stepper.controlSize = .small
        stepper.target = self
        stepper.action = #selector(stepper(sender:))
        stepper.valueWraps = false
        stepper.increment = 0.05
        stepper.minValue = -.greatestFiniteMagnitude
        stepper.maxValue = .greatestFiniteMagnitude
        
        let stackView = NSStackView(views: [textField, stepper])
        
        stackView.alignment = .centerY
        stackView.distribution = .equalSpacing
        stackView.orientation = .horizontal
        stackView.spacing = 2.0
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: stackView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        addSubview(stackView)
    }
}

extension NumberStepper: NSTextFieldDelegate {
    
    @objc func stepper(sender: NSStepper) {
        
        textField.doubleValue = Math.quantize(value: stepper.doubleValue)
        
        valueDidChange?(self, stepper.doubleValue)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        
        stepper.doubleValue = Math.quantize(value: textField.doubleValue)
        
        valueDidChange?(self, stepper.doubleValue)
    }
}
