//
//  Exception.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
 * Utility class used to throw an exception if something wrong happened
 */
public class Exception {
    
    @discardableResult
    public init(_ message: String) {
        fatalError(message)
    }
}
