//
//  ColorProvider.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

/**
 * Utility class that should be used to access every color
 */
public class ColorProvider {
    
    public static func get(_ named: String) -> UIColor? {
        if #available(iOS 13.0, *) {
            return UIColor(named: named, in: mainBundle, compatibleWith: .current)
        } else {
            return UIColor(named: named, in: mainBundle, compatibleWith: .none)
        }
    }
}
