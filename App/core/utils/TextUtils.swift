//
//  TextUtils.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
 * Utility class that provides some useful methods to manage strings
 */
public class TextUtils {
    
    public static func isEmpty(_ string: String?) -> Bool {
        return string?.isEmpty ?? true
    }
}
