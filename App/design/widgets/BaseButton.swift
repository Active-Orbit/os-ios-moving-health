//
//  BaseButton.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

@IBDesignable
public class BaseButton: UIButton {
    
    public static let TYPE_PRIMARY = 0
    public static let TYPE_SECONDARY = 1
    public static let TYPE_TERTIARY = 2
    public static let TYPE_MAIN_SCREEN = 3
    public static let TYPE_DEFAULT = TYPE_PRIMARY
    
    public static let ICON_POSITION_CENTER = 0
    public static let ICON_POSITION_START = 1
    public static let ICON_POSITION_END = 2
    
    fileprivate var mType = TYPE_DEFAULT
    fileprivate var realTextSize: CGFloat?
    fileprivate var realFontName: String?
    
    var uppercased = false
    
    fileprivate var mIcon = Constants.INVALID
    fileprivate var mIconSymmetry = true
    fileprivate var mIconPosition = Constants.INVALID
    
    fileprivate var clickListener: (() -> Void)?
    fileprivate var isPressed = false
    
    @IBOutlet var mTitle: BaseLabel!
    @IBOutlet weak var mIconStart: BaseImageView!
    @IBOutlet weak var mIconEnd: BaseImageView!
    
    @IBInspectable public var localizedTitle: String {
        set(key) {
            mTitle.text = uppercased ? StringProvider.get(key).uppercased() : StringProvider.get(key)
        }
        get {
            return mTitle.text!
        }
    }
    
    var title: String {
        set {
            mTitle.text = textAllCaps ? newValue.uppercased() : newValue
        }
        get {
            return mTitle.text!
        }
    }
    
    @IBInspectable public var type: Int {
        set {
            mType = newValue
            update()
        }
        get {
            return mType
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            update()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    fileprivate func prepare() {
        loadXib(name: "BaseButton")
        cornerRadius = DimensionProvider.BUTTON_RADIUS
        borderWidth = DimensionProvider.BUTTON_STROKE
        
        addTarget(self, action: #selector(self.setPressed), for: .touchDown)
        addTarget(self, action: #selector(self.setUnpressed), for: .touchCancel)
        addTarget(self, action: #selector(self.setUnpressed), for: .touchUpInside)
        addTarget(self, action: #selector(self.setUnpressed), for: .touchUpOutside)
        addTarget(self, action: #selector(self.onClick), for: .touchUpInside)
    }
    
    func setType(_ type: Int) {
        mType = type
        update()
    }
    
    func setText(_ text: String?) {
        title = text ?? Constants.EMPTY
    }
    
    func setIconPosition(_ position: Int) {
        mIconPosition = position
    }
    
    func setIconSymmetry(_ symmetry: Bool) {
        mIconSymmetry = symmetry
    }
    
    func setIcon(_ icon: UIImage?, center: Bool = false, start: Bool = false) {
        if center {
            mTitle.isHidden = true
            mIconEnd.isHidden = true
            mIconStart.isHidden = false
            mIconStart.image = icon
        } else {
            if start {
                mTitle.isHidden = false
                if mIconSymmetry {
                    mIconEnd.isHidden = false
                    mIconEnd.image = nil
                } else {
                    mIconEnd.isHidden = true
                }
                mIconStart.alpha = Constants.ALPHA_ENABLED
                mIconStart.isHidden = false
                mIconStart.image = icon
            } else {
                mTitle.isHidden = false
                if mIconSymmetry {
                    mIconStart.isHidden = false
                    mIconStart.image = nil
                } else {
                    mIconStart.isHidden = true
                }
                mIconEnd.alpha = Constants.ALPHA_ENABLED
                mIconEnd.isHidden = false
                mIconEnd.image = icon
            }
        }
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
            mTitle.font = UIFont(name: realFontName!, size: realTextSize!)
            mTitle.font = mTitle.font.withSize(realTextSize!)
        }
    }
    
    public override func setOnClickListener(target: Any?, listener: Selector?, cancelsTouchesInView: Bool = true) {
        Exception("Do not set selector listeners on buttons, use targets")
        return
    }
    
    public func setOnClickListener(_ listener: @escaping (() -> Void)) {
        clickListener = listener
    }
    
    @objc func setPressed() {
        isPressed = true
        update()
    }
    
    @objc func setUnpressed() {
        isPressed = false
        update()
    }
    
    @objc func onClick() {
        clickListener?()
    }
    
    fileprivate func update() {
        defaultBackgroundColor()
        defaultTextColor()
    }
    
    fileprivate func defaultBackgroundColor() {
        if isEnabled {
            switch mType {
                case BaseButton.TYPE_PRIMARY:
                    if isPressed {
                        backgroundColor = ColorProvider.get("colorAccent")
                        borderColor = ColorProvider.get("colorAccent")
                    } else {
                        backgroundColor = ColorProvider.get("colorPrimary")
                        borderColor = ColorProvider.get("colorPrimary")
                    }
                case BaseButton.TYPE_SECONDARY:
                    if isPressed {
                        backgroundColor = ColorProvider.get("colorSecondary")
                        borderColor = ColorProvider.get("colorSecondary")
                    } else {
                        backgroundColor = ColorProvider.get("white")
                        borderColor = ColorProvider.get("colorSecondary")
                    }
                case BaseButton.TYPE_TERTIARY:
                    if isPressed {
                        backgroundColor = ColorProvider.get("white")
                        borderColor = ColorProvider.get("colorAccent")
                    } else {
                        backgroundColor = ColorProvider.get("white")
                        borderColor = ColorProvider.get("colorPrimary")
                    }
                case BaseButton.TYPE_MAIN_SCREEN:
                    if isPressed {
                        backgroundColor = ColorProvider.get("colorAccent")
                        borderColor = ColorProvider.get("colorAccent")
                    } else {
                        backgroundColor = ColorProvider.get("colorPrimary")
                        borderColor = ColorProvider.get("colorPrimary")
                    }
                default:
                    Logger.e("Undefined button type \(mType)")
            }
        } else {
            backgroundColor = ColorProvider.get("colorPrimaryLight")
            borderColor = ColorProvider.get("colorPrimaryLight")
        }
    }
    
    fileprivate func defaultTextColor() {
        if isEnabled {
            switch mType {
                case BaseButton.TYPE_PRIMARY:
                    mTitle.textColor = ColorProvider.get("textColorWhite")
                case BaseButton.TYPE_SECONDARY:
                    if isPressed {
                        mTitle.textColor = ColorProvider.get("textColorWhite")
                    } else {
                        mTitle.textColor = ColorProvider.get("textColorPrimaryDark")
                    }
                case BaseButton.TYPE_TERTIARY:
                    mTitle.textColor = ColorProvider.get("textColorPrimaryDark")
                case BaseButton.TYPE_MAIN_SCREEN:
                    mTitle.textColor = ColorProvider.get("textColorPrimary")
                default:
                    Logger.e("Undefined button type \(mType)")
            }
        } else {
            mTitle.textColor = ColorProvider.get("colorPrimary")
        }
    }
}
