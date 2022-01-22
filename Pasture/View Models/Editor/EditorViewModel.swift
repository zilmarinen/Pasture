//
//  EditorViewModel.swift
//
//  Created by Zack Brown on 21/10/2021.
//

import Euclid
import SceneKit
import SwiftUI

class EditorViewModel: ObservableObject {
    
    let scene = EditorScene()
    
    @Published var prototype = EditorFoliage() {
        
        didSet {
            
            let mesh = prototype.mesh

            scene.model.geometry = SCNGeometry(mesh)
            scene.wireframe.geometry = SCNGeometry(wireframe: mesh)
            scene.wireframe.footprint = prototype.footprint
        }
    }
    
    @Published var showWireframes: Bool = true {
        
        didSet {
            
            scene.wireframe.isHidden = !showWireframes
        }
    }
}
