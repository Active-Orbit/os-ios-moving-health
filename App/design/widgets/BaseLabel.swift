//
//  BaseLabel.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

@IBDesignable
public class BaseLabel: UILabel {
    
    fileprivate var realTextSize: CGFloat?
    fileprivate var realFontName: String?
    
    var uppercased = false
    
    public var padding: CGFloat = 0
    public var paddingLeft: CGFloat = 0
    public var paddingTop: CGFloat = 0
    public var paddingRight: CGFloat = 0
    public var paddingBottom: CGFloat = 0
    
    fileprivate var isClickable = false
    fileprivate var clickListener: (() -> Void)?
    
    @IBInspectable public var clickable: Bool {
        set {
            isClickable = newValue
            isUserInteractionEnabled = isClickable
        }
        get {
            return isClickable
        }
    }
    
    public override func setOnClickListener(target: Any?, listener: Selector?, cancelsTouchesInView: Bool = true) {
        super.setOnClickListener(target: target, listener: listener)
        clickable = listener != nil
    }
    
    public func setOnClickListener(_ listener: @escaping (() -> Void)) {
        clickListener = listener
        setOnClickListener(target: self, listener: #selector(onClick))
    }
    
    @objc fileprivate func onClick() {
        clickListener?()
    }
    
    public override func disableTouches() {
        super.disableTouches()
        clickable = false
    }
    
    @IBInspectable public var localizedText: String {
        set (key) {
            text = uppercased ? StringProvider.get(key).uppercased() : StringProvider.get(key)
        }
        get {
            return text!
        }
    }
    
    public var textTrim : String {
        return text == nil ? Constants.EMPTY : text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func setTextSize(textSize: CGFloat) {
        realTextSize = textSize
        setupFont()
    }
    
    func setFontName(fontName: String) {
        realFontName = fontName
        setupFont()
    }
    
    fileprivate func setupFont() {
        if realTextSize != nil && realFontName != nil {
            font = UIFont(name: realFontName!, size: realTextSize!)
            font = font.withSize(realTextSize!)
        }
    }
    
    public func clear() {
        text = Constants.EMPTY
    }
}

extension BaseLabel {
    
    override public func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: max(padding, paddingTop), left: max(padding, paddingLeft), bottom: max(padding, paddingBottom), right: max(padding, paddingRight))
        super.drawText(in: rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + (padding * 2), height: size.height + (padding * 2))
    }
}

extension BaseLabel {

    public func setLineSpacing(_ lineSpacing: CGFloat = 0.0) {

        guard let labelText = text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = 0
        paragraphStyle.alignment = textAlignment

        let attributedString: NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // line spacing attribute
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
}
