//
//  FontExtension.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func loadFont(name: String) {
        let pathForResourceString = mainBundle.path(forResource: name, ofType: "ttf")
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil
        
        if CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false {
            Logger.e("Failed to register font with name \(name)")
        }
    }
}
