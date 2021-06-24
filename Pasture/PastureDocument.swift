//
//  PastureDocument.swift
//
//  Created by Zack Brown on 11/06/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    
    static var model: UTType {
        
        UTType(importedAs: "com.so.pasture.model")
    }
}

extension PastureDocument {
    
    enum Constants {
        
        enum Formatters {
            
            static var double: NumberFormatter {
                
                let f = NumberFormatter()
                
                f.minimumFractionDigits = 3
                
                return f
            }
            
            static var integer: NumberFormatter { NumberFormatter() }
        }
    }
}

struct PastureDocument: FileDocument, Codable {
    
    static var readableContentTypes: [UTType] { [.model] }
    
    var model: Model

    init(name: String = "Model") {
        
        self.model = Model(name: name)
    }

    init(configuration: ReadConfiguration) throws {
        
        guard let data = configuration.file.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
        
        do {
            
            self = try JSONDecoder().decode(Self.self, from: data)
        }
        catch {
            
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func snapshot(contentType: UTType) throws -> Model { model }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        
        let data = try JSONEncoder().encode(self)
        
        return FileWrapper(regularFileWithContents: data)
    }
}

