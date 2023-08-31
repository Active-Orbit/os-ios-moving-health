//
//  TextSizeProvider.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

/**
 * Utility class that should be used to access every text size
 */

public enum TextSizeProvider {
    
    case DEFAULT
    case H0
    case H1
    case H2
    case H3
    case H4
    case H5
    case H6
    case H7
    
    public var size: CGFloat {
        switch self {
            case .DEFAULT: return TextSizeProvider.H2.size
            case .H0: return 42
            case .H1: return 38
            case .H2: return 28
            case .H3: return 24
            case .H4: return 20
            case .H5: return 16
            case .H6: return 12
            case .H7: return 8
        }
    }
    
    static func getTextSize(index: CGFloat) -> CGFloat {
        if index.isNaN {
            Logger.e("Index for text size is not a number")
        } else {
            switch index {
                case 0 : return TextSizeProvider.H0.size
                case 1 : return TextSizeProvider.H1.size
                case 2 : return TextSizeProvider.H2.size
                case 3 : return TextSizeProvider.H3.size
                case 4 : return TextSizeProvider.H4.size
                case 5 : return TextSizeProvider.H5.size
                case 6 : return TextSizeProvider.H6.size
                case 7 : return TextSizeProvider.H7.size
                default : return index
            }
        }
        return TextSizeProvider.DEFAULT.size
    }
}
