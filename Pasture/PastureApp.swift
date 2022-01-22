//
//  PastureApp.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import SwiftUI

@main
struct PastureApp: App {
    
    enum Constants {
            
            static let padding = 8.0
            static let cornerRadius = 8.0
            
            static let edgeInsets = EdgeInsets(top: 2, leading: padding, bottom: 2, trailing: padding)
        
            static let toolWidth = 280.0
            static let editorWidth = 350.0
        }
    
    var body: some Scene {
        
        WindowGroup() {
            
            AppView(model: .init())
        }
    }
}
