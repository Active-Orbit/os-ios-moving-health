//
//  BaseTextField.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

@IBDesignable
public class BaseTextField: UITextField {
    
    fileprivate var realTextSize: CGFloat?
    fileprivate var realFontName: String?
    
    fileprivate var isClickable = false
    fileprivate var clickListener: (() -> Void)?
    
    var uppercased = false
    
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
    
    @IBInspectable public var localizedPlaceholder: String {
        set (value) {
            placeholder = StringProvider.get(value)
        }
        get {
            return placeholder!
        }
    }
    
    @IBInspectable public var colorPlaceholder: UIColor {
        set (value) {
            let string = placeholder ?? Constants.EMPTY
            attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: value])
        }
        get {
            // TODO
            return UIColor.gray
        }
    }
    
    public var textTrim : String {
        return text == nil ? Constants.EMPTY : text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
        addToolbar()
        cornerRadius = 8
        borderColor = ColorProvider.get("colorEditTextBorder")
        borderWidth = 1
        
        colorPlaceholder = ColorProvider.get("textColorGray")!
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
            font = font?.withSize(realTextSize!)
        }
    }
    
    func clear() {
        text = Constants.EMPTY
    }
    
    func addToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: DimensionProvider.TOOLBAR_KEYBOARD_HEIGHT))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(title: StringProvider.get("done").localizedUppercase, style: .done, target: self, action: #selector(self.resignFirstResponder))
        item.tintColor = ColorProvider.get("colorAccent")
        toolbar.items = [space, item]
        inputAccessoryView = toolbar
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 6);
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 6);
    }
}

private var rightViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
private var errorViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)

extension UITextField {
    // Add/remove error message
    func setError(_ view: UIView, message: String? = nil, show: Bool = true) {
     

        // Add right button to textField
        let errorButton = BaseImageView()
        errorButton.tag = 999
        errorButton.image = ImageProvider.get("ic_error")
        errorButton.frame = CGRect(x: 0, y: 0, width: frame.size.height, height: frame.size.height)
        rightView = errorButton
        rightViewMode = .always
        
        
        if !show {
            errorButton.visibility = .gone
        } else{
            errorButton.visibility = .visible
            errorButton.setOnClickListener {
                if message != nil {
                    Toast.showLongToast(view, message!)
                }
            }
        }
    }


}

