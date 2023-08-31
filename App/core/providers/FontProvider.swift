//
//  FontProvider.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

/**
 * Utility class that should be used to access every font
 */
public enum FontProvider {
    
    case DEFAULT
    case REGULAR
    case BOLD
    case SEMIBOLD
    case ITALIC
    case BLACK
    case LIGHT
    case BOLD_ITALIC
    case MEDIUM
    
    var name: String {
        switch self {
            case .DEFAULT: return FontProvider.REGULAR.name
            case .REGULAR: return "Rubik-Regular"
            case .BOLD: return "Rubik-Bold"
            case .SEMIBOLD: return "Rubik-SemiBold"
            case .ITALIC: return "Rubik-Italic"
            case .BLACK: return "Rubik-Black"
            case .LIGHT: return "Rubik-Light"
            case .BOLD_ITALIC: return "Rubik-BoldItalic"
            case .MEDIUM: return "Rubik-Medium"
        }
    }
    
    static func getFontName(index: CGFloat) -> String {
        if index.isNaN {
            Logger.e("Index for text font is not a number")
        } else {
            switch index {
                case 0 : return FontProvider.REGULAR.name
                case 1 : return FontProvider.BOLD.name
                case 2 : return FontProvider.SEMIBOLD.name
                case 3 : return FontProvider.ITALIC.name
                case 4 : return FontProvider.BLACK.name
                case 5 : return FontProvider.LIGHT.name
                case 6 : return FontProvider.BOLD_ITALIC.name
                case 7 : return FontProvider.MEDIUM.name
                default : Logger.e("Index for text font is not correct")
            }
        }
        return FontProvider.DEFAULT.name
    }
    
    static func load() {
        UIFont.loadFont(name: "regular")
        UIFont.loadFont(name: "bold")
        UIFont.loadFont(name: "semibold")
        UIFont.loadFont(name: "italic")
        UIFont.loadFont(name: "black")
        UIFont.loadFont(name: "light")
        UIFont.loadFont(name: "bold-italic")
        UIFont.loadFont(name: "medium")
    }
}
