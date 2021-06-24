//
//  PastureApp.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import Meadow
import Metal
import MetalKit
import SwiftUI

@main
struct PastureApp: App {
    
    var body: some SwiftUI.Scene {
        
        guard let asset = NSDataAsset(name: "workspace") else { fatalError("Unable to load workspace scene") }
        
        var scene: MDWScene
        
        do {
            
            let meadow = try JSONDecoder().decode(Meadow.self, from: asset.data)
        
            scene = MDWScene(meadow: meadow)
        
            scene.hero.isHidden = true
            
            let device = MTLCreateSystemDefaultDevice()
            
            scene.library = try device?.makeDefaultLibrary(bundle: Meadow.bundle)
        }
        catch {
            
            fatalError("Unable to load workspace scene: \(error)")
        }
        
        return DocumentGroup(newDocument: PastureDocument()) { file in
            
            ContentView(document: file.$document, scene: scene)
        }
    }
}
