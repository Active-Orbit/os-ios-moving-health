//
//  TextExtension.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

extension UIView {
    
    @IBInspectable public var textSize: CGFloat {
        set {
            let fixedTextSize = TextSizeProvider.getTextSize(index: newValue)
            if let instance = self as? BaseLabel {
                instance.setTextSize(textSize: fixedTextSize)
            } else if let instance = self as? BaseTextField {
                instance.setTextSize(textSize: fixedTextSize)
            } else if let instance = self as? BaseTextView {
                instance.setTextSize(textSize: fixedTextSize)
            } else if let instance = self as? BaseButton {
                instance.setTextSize(textSize: fixedTextSize)
            }
        }
        get {
            return self.textSize
        }
    }
    
    @IBInspectable public var textFont: CGFloat {
        set {
            let fontName = FontProvider.getFontName(index: newValue)
            if let instance = self as? BaseLabel {
                instance.setFontName(fontName: fontName)
            } else if let instance = self as? BaseTextField {
                instance.setFontName(fontName: fontName)
            } else if let instance = self as? BaseTextView {
                instance.setFontName(fontName: fontName)
            } else if let instance = self as? BaseButton {
                instance.setFontName(fontName: fontName)
            }
        }
        get {
            return self.textFont
        }
    }
    
    @IBInspectable var textAllCaps: Bool {
        set {
            if let instance = self as? BaseLabel {
                instance.uppercased = true
                instance.text = instance.text?.uppercased()
            } else if let instance = self as? BaseTextField {
                instance.uppercased = true
                instance.text = instance.text?.uppercased()
            } else if let instance = self as? BaseTextView {
                instance.uppercased = true
                instance.text = instance.text?.uppercased()
            } else if let instance = self as? BaseButton {
                instance.uppercased = true
                instance.title = instance.title.uppercased()
            }
        }
        get {
            if let instance = self as? BaseLabel {
                return instance.uppercased
            } else if let instance = self as? BaseTextField {
                return instance.uppercased
            } else if let instance = self as? BaseTextView {
                return instance.uppercased
            } else if let instance = self as? BaseButton {
                return instance.uppercased
            }
            return false
        }
    }
}
