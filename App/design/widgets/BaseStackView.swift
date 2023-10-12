//
//  BaseStackView.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

open class BaseStackView: UIStackView {
    
    public func setBackground(color: UIColor?, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = color
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.cornerRadius = cornerRadius
        backgroundView.borderWidth = borderWidth
        backgroundView.borderColor = borderColor
        insertSubview(backgroundView, at: 0)
    }
}

