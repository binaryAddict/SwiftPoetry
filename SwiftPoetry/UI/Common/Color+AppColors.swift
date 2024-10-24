//
//  Color+AppColors.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import SwiftUI

extension Color {
    
    static let color1 = Color(red: 0x75, green: 0x8E, blue: 0xA2)
    static let color2 = Color(red: 0x54, green: 0x6A, blue: 0x7b)
    static var appTint: Color {
        .pink
//        .color2
    }
    
    init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            opacity: a
        )
    }
}
