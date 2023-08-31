//
//  AbstractDialog.swift
//  BaseApp
//
//  Created by Omar Brugna on 12/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

open class AbstractDialog: UIView {
    
    public static let TAG_DIALOG = 372837
    
    fileprivate var mWindow: UIWindow?
    fileprivate var keyboardShown = false
    public var isVisible = false
    
    open func getXibName() -> String {
        // override to customize
        Exception("Called method in abstract dialog class")
        return Constants.EMPTY
    }
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        prepare()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        Exception("Do not use this constructor for \(className)")
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        Exception("Do not use this constructor for \(className)")
    }
    
    fileprivate func prepare() {
        let xibName = getXibName()
        loadXib(name: xibName)
        onViewPrepared()
    }
    
    open func onViewPrepared() {
        mWindow = UIWindow(frame: UIScreen.main.bounds)
        mWindow?.tag = AbstractDialog.TAG_DIALOG
        mWindow?.windowLevel = .alert
        mWindow?.backgroundColor = ColorProvider.get("colorDialog")
        mWindow?.addSubview(self)
        
        center = CGPoint(x: mWindow?.bounds.midX ?? 0, y: mWindow?.bounds.midY ?? 0)
    }
    
    public func setCancelable(_ value: Bool) {
        if value {
            setOnClickListener(target: self, listener: #selector(hide(animated:)))
        } else {
            setOnClickListener(target: self, listener: nil)
        }
    }
    
    public func onKeyboardWillShow(keyboardFrame: CGRect) {
        if !keyboardShown {
            self.frame.size.height -= keyboardFrame.size.height
        }
        keyboardShown = true
    }
    
    public func onKeyboardWillHide(keyboardFrame: CGRect) {
        if keyboardShown {
            self.frame.size.height += keyboardFrame.size.height
        }
        keyboardShown = false
    }
    
    open override var isHidden: Bool {
        set {
            mWindow?.isHidden = newValue
        }
        get {
            return mWindow?.isHidden ?? true
        }
    }
    
    open func onDidShow() {
        // override to customize
    }
    
    open func onDidHide() {
        // override to customize
    }
    
    public func show(animated: Bool = true) {
        isVisible = true
        if animated {
            mWindow?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            mWindow?.alpha = 0
            mWindow?.makeKeyAndVisible()
            UIView.animate(withDuration: DurationProvider.ANIMATION, animations: {
                self.mWindow?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.mWindow?.alpha = Constants.ALPHA_ENABLED
            }, completion: { _ in
                self.onDidShow()
            })
        } else {
            mWindow?.makeKeyAndVisible()
            onDidShow()
        }
    }
    
    @objc public func hide(animated: Bool = true) {
        mWindow?.backgroundColor = ColorProvider.get("colorTransparent")
        if animated {
            UIView.animate(withDuration: DurationProvider.ANIMATION, animations: {
                self.mWindow?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.mWindow?.alpha = 0
            }, completion: { _ in
                self.mWindow?.resignKey()
                self.mWindow = nil
                self.isVisible = false
                self.onDidHide()
            }
            )
        } else {
            mWindow?.isHidden = true
            mWindow = nil
            isVisible = false
            onDidHide()
        }
    }
}
