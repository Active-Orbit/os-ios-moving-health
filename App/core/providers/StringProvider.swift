//
//  StringProvider.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import Foundation

/**
 * Utility class that should be used to access every string
 */
public class StringProvider {
    
    public static let TABLE_DEFAULT = "Localizable"
    
    public static func get(_ key: String, tableName: String = TABLE_DEFAULT) -> String {
        return NSLocalizedString(key, tableName: tableName, bundle: mainBundle, value: Constants.EMPTY, comment: Constants.EMPTY)
    }
}
