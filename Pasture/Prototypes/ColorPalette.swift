//
//  ColorPalette.swift
//
//  Created by Zack Brown on 27/10/2021.
//

import Euclid

struct ColorPalette {
    
    let primary: Color
    let secondary: Color
    let tertiary: Color
    let quaternary: Color
}

extension ColorPalette {
    
    static let bamboo = ColorPalette(primary: Color(0.952, 0.929, 0.619),
                                     secondary: Color(0.639, 0.854, 0.552),
                                     tertiary: Color(0.333, 0.486, 0.333),
                                     quaternary: Color(0.847, 0.913, 0.658))
    
    static let hebe = ColorPalette(primary: Color(0.952, 0.929, 0.619),
                                   secondary: Color(0.639, 0.854, 0.552),
                                   tertiary: Color(0.333, 0.486, 0.333),
                                   quaternary: Color(0.847, 0.913, 0.658))
    
    static let gingko = ColorPalette(primary: Color(0.952, 0.874, 0.537),
                                     secondary: Color(0.941, 0.768, 0.247),
                                     tertiary: Color(0.933, 0.69, 0.027),
                                     quaternary: Color(0.952, 0.878, 0.631))
    
    static let cherryBlossom = ColorPalette(primary: Color(1.0, 0.631, 0.788),
                                            secondary: Color(0.976, 0.282, 0.572),
                                            tertiary: Color(0.439, 0.345, 0.321),
                                            quaternary: Color(0.313, 0.231, 0.239))
    
    static let stump = ColorPalette(primary: Color(0.541, 0.525, 0.207),
                                    secondary: Color(0.196, 0.313, 0.180),
                                    tertiary: Color(0.490, 0.352, 0.313),
                                    quaternary: Color(0.525, 0.329, 0.223))
}
