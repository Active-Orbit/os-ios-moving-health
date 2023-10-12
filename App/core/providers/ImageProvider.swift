//
//  ImageProvider.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

/**
 * Utility class that should be used to access every image
 */
import UIKit

public class ImageProvider {
    
    public static func get(_ named: String) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(named: named, in: mainBundle, compatibleWith: .current)
        } else {
            return UIImage(named: named, in: mainBundle, compatibleWith: .none)
        }
    }
}
