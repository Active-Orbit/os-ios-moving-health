//
//  BaseView.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

open class BaseView: UIView {
    
    public var intrinsicWidth: CGFloat = 0
    public var intrinsicHeight: CGFloat = 0
    
    fileprivate var clickListener: (() -> Void)?
    
    public func setOnClickListener(_ listener: @escaping (() -> Void)) {
        clickListener = listener
        setOnClickListener(target: self, listener: #selector(onClick))
    }
    
    @objc fileprivate func onClick() {
        clickListener?()
    }
    
    public func performClick() {
        clickListener?()
    }
    
    override public var intrinsicContentSize: CGSize {
        if intrinsicWidth == 0 && intrinsicHeight == 0 {
            return super.intrinsicContentSize
        }
        var size = super.intrinsicContentSize
        if intrinsicWidth != 0 { size.width = intrinsicWidth }
        if intrinsicHeight != 0 { size.height = intrinsicHeight }
        return CGSize(width: size.width, height: size.height)
    }
}
