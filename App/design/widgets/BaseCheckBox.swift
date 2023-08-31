//
//  BaseCheckBox.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

public class BaseCheckBox: UIButton {
    
    fileprivate let checkedImage = ImageProvider.get("ic_check")
    fileprivate var checkedListener: ((Bool) -> Void)?
    fileprivate var clickListener: (() -> Void)?

    
    @IBInspectable public var isChecked: Bool = false {
        didSet {
            if isChecked {
                borderWidth = 0
                backgroundColor = ColorProvider.get("colorAccent")
                setBackgroundImage(checkedImage, for: .normal)
            } else {
                borderWidth = DimensionProvider.CHECKBOX_STROKE
                backgroundColor = ColorProvider.get("colorTransparent")
                setBackgroundImage(nil, for: .normal)
            }
            checkedListener?(isChecked)
        }
    }
    
    // MARK: init methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    fileprivate func prepare() {
        cornerRadius = DimensionProvider.CHECKBOX_RADIUS
        borderWidth = DimensionProvider.CHECKBOX_STROKE
        borderColor = ColorProvider.get("colorGray")
        
        addTarget(self, action: #selector(self.onClick), for: .touchUpInside)

    }
    
    public func setOnCheckedChangedListener(_ listener: @escaping ((Bool) -> Void)) {
        checkedListener = listener
    }
    
    // MARK: click methods
    
    @objc func toggle() {
        isChecked = !isChecked
    }
    
    public override func setOnClickListener(target: Any?, listener: Selector?, cancelsTouchesInView: Bool = true) {
        Exception("Do not set selector listeners on buttons, use targets")
        return
    }
    
    public func setOnClickListener(_ listener: @escaping (() -> Void)) {
        clickListener = listener
    }
    
    @objc func onClick() {
        clickListener?()
    }
}
