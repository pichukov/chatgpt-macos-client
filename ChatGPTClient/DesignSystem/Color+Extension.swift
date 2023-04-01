//
//  Color+Extension.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import SwiftUI
import AppKit

public extension Color {
    
    // Text
    static let textBackground = color(name: "textBackground")

    // General
    static let border = color(name: "border")

    private static func color(name: String) -> Color {
        if NSColor(named: name) != nil {
            return SwiftUI.Color(name, bundle: .main)
        } else {
            return Color.yellow
        }
    }

    var nsColor: NSColor {
        return NSColor(self)
    }
}
