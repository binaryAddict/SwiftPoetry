//
//  Color+AppColors.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import SwiftUI

extension Color {
    
    private static let traditionalB_option1 = Color(red: 0x75, green: 0x8E, blue: 0xA2)
    private static let traditionalB_option2 = Color(red: 0x54, green: 0x6A, blue: 0x7B)
    private static let moderTint = Color(red: 0x6F, green: 0x2F, blue: 0xDC)
    
    static var appTint: Color {
        switch AppStyle.current {
        case .modern:
            return .moderTint
        case .traditionalA:
            return .pink
        case .traditionalB:
            return .traditionalB_option1
        }
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
