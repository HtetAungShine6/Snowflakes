//
//  AppColor.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/11/2024.
//

import SwiftUI

struct AppColors {
    static let iceBlue = Color(hex: "#D0F0FF")
    static let frostBlue = Color(hex: "#B0E3F5")
    static let arcticSky = Color(hex: "#80CFFF")
    static let glacialBlue = Color(hex: "#4DB8E8")
    static let frozenDepth = Color(hex: "#297BA7")
    static let polarBlue = Color(hex: "#309CFF")
    static let lightGray = Color(hex: "#FDFDFD")
    static let FontColor = Color (hex: "#000000")
}

extension Color {
    init(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        let scanner = Scanner(string: hexString)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
