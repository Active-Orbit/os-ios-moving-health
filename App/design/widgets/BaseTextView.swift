//
//  BaseTextView.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

@IBDesignable
public class BaseTextView: UITextView {
    
    fileprivate var realTextSize: CGFloat?
    fileprivate var realFontName: String?
    
    var uppercased = false
    
    public var padding: CGFloat = 0
    public var paddingLeft: CGFloat = 0
    public var paddingTop: CGFloat = 0
    public var paddingRight: CGFloat = 0
    public var paddingBottom: CGFloat = 0
    
    var placeholderView: BaseTextView?
    
    var placeholder: String? {
        didSet {
            showPlaceholder()
        }
    }
    
    @IBInspectable public var localizedPlaceholder: String {
        set (key) {
            placeholder = StringProvider.get(key)
        }
        get {
            return placeholder!
        }
    }
    
    @IBInspectable public var localizedText: String {
        set (key) {
            text = uppercased ? StringProvider.get(key).uppercased() : StringProvider.get(key)
        }
        get {
            return text!
        }
    }
    
    var toolbarEnabled = true
    @IBInspectable public var enableToolbar: Bool {
        set {
            toolbarEnabled = newValue
        }
        get {
            return toolbarEnabled
        }
    }
    
    public var textTrim : String {
        return text == nil ? Constants.EMPTY : text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var textTrimRemovingEmptyLines : String {
        var array: [String] = []
        textTrim.enumerateLines { line, _ in array.append(line) }
        return array.filter{!$0.isEmpty}.joined(separator: "\n")
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        if toolbarEnabled {
            addToolbar()
        }
    }
    
    func clear() {
        text = Constants.EMPTY
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
    
    func addToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: DimensionProvider.TOOLBAR_KEYBOARD_HEIGHT))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(title: StringProvider.get("done").localizedUppercase, style: .done, target: self, action: #selector(self.resignFirstResponder))
        item.tintColor = ColorProvider.get("colorAccent")
        toolbar.items = [space, item]
        inputAccessoryView = toolbar
    }
}

extension BaseTextView {
    
    public override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: max(padding, paddingTop), left: max(padding, paddingLeft), bottom: max(padding, paddingBottom), right: max(padding, paddingRight))
        super.draw(rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + (padding * 2), height: size.height + (padding * 2))
    }
}

extension BaseTextView {
    
    // MARK: placeholder methods
    
    public func showPlaceholder() {
        if !TextUtils.isEmpty(placeholder) {
            if placeholderView == nil {
                placeholderView = BaseTextView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40))
                placeholderView!.text = placeholder
                placeholderView!.backgroundColor = ColorProvider.get("colorTransparent")
                placeholderView!.textColor = ColorProvider.get("gray")
                placeholderView!.font = font
                placeholderView!.sizeToFit()
                placeholderView!.layoutIfNeeded()
                placeholderView!.isUserInteractionEnabled = false
                addSubview(placeholderView!)
            }
            placeholderView!.isHidden = false
        }
    }
    
    public func hidePlaceholder() {
        placeholderView?.isHidden = true
    }
    
    public func managePlaceholder() {
        if TextUtils.isEmpty(text) {
            showPlaceholder()
        } else {
            hidePlaceholder()
        }
    }
}
