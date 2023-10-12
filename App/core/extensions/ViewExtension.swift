//
//  ViewExtension.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

extension UIView {
    
    // MARK: xib methods
    
    @discardableResult
    public func loadXib(name: String) -> UIView {
        return loadXib(name: name, inView: self)
    }
    
    @discardableResult
    public func loadXib(name: String, inView view: UIView) -> UIView {
        let xibView = loadViewFromXib(name)
        xibView.frame = view.bounds
        view.addSubview(xibView)
        return xibView
    }
    
    fileprivate func loadViewFromXib(_ name: String!) -> UIView {
        let nib = UINib(nibName: name, bundle: mainBundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
}

extension UIView {
    
    // MARK: touch methods
    
    @objc open func setOnClickListener(target: Any?, listener: Selector?, cancelsTouchesInView: Bool = true) {
        if listener != nil {
            let tap = UITapGestureRecognizer(target: target, action: listener)
            tap.numberOfTapsRequired = 1
            tap.cancelsTouchesInView = cancelsTouchesInView
            isUserInteractionEnabled = true
            addGestureRecognizer(tap)
        } else {
            if gestureRecognizers != nil {
                for gestureRecognizer in gestureRecognizers! {
                    removeGestureRecognizer(gestureRecognizer)
                }
            }
        }
    }
    
    @objc open func disableTouches() {
        setOnClickListener(target: self, listener: #selector(fakeTouch), cancelsTouchesInView: false)
    }
    
    @objc public func fakeTouch() {
        // do nothing
    }
}

extension UIView {
    
    // MARK: utility methods
    
    public func rounded() {
        cornerRadius = frame.size.width / 2
    }
    
    public func invalidate() {
        mainThread {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    public var corners : CACornerMask {
        set {
            layer.maskedCorners = newValue
        }
        get {
            return layer.maskedCorners
        }
    }
    
    public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    public func hideKeyboard() {
        endEditing(true)
    }
    
    public func showShadow() {
        layer.shadowColor = ColorProvider.get("gray")?.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    /**
     Utility method to compute the optimal height required by this view according to the children height
     - parameter fittingWidth the required width
     - returns: the computed height
     */
    public func wrapContentHeight(fittingWidth: CGFloat) -> CGFloat {
        var fittingSize = UIView.layoutFittingExpandedSize
        fittingSize.width = fittingWidth
        let size = systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .defaultLow
        )
        return size.height
    }
}

extension UIView {
    
    // MARK: visibility methods
    
    public enum Visibility : Int {
        case visible = 0
        case invisible = 1
        case gone = 2
        case goneY = 3
        case goneX = 4
    }
    
    public var visibility: Visibility {
        set {
            switch newValue {
                case .visible:
                    isHidden = false
                    getConstraintY(false)?.isActive = false
                    getConstraintX(false)?.isActive = false
                case .invisible:
                    isHidden = true
                    getConstraintY(false)?.isActive = false
                    getConstraintX(false)?.isActive = false
                case .gone:
                    isHidden = true
                    getConstraintY(true)?.isActive = true
                    getConstraintX(true)?.isActive = true
                case .goneY:
                    isHidden = true
                    getConstraintY(true)?.isActive = true
                    getConstraintX(false)?.isActive = false
                case .goneX:
                    isHidden = true
                    getConstraintY(false)?.isActive = false
                    getConstraintX(true)?.isActive = true
            }
        }
        get {
            if isHidden == false {
                return .visible
            }
            if getConstraintY(false)?.isActive == true && getConstraintX(false)?.isActive == true {
                return .gone
            }
            if getConstraintY(false)?.isActive == true {
                return .goneY
            }
            if getConstraintX(false)?.isActive == true {
                return .goneX
            }
            return .invisible
        }
    }
    
    fileprivate func getConstraintY(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        return getConstraint(.height, createIfNotExists)
    }
    
    fileprivate func getConstraintX(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        return getConstraint(.width, createIfNotExists)
    }
    
    fileprivate func getConstraint(_ attribute: NSLayoutConstraint.Attribute, _ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        let identifier = "tt_constraint"
        var result: NSLayoutConstraint? = nil
        for constraint in constraints {
            if constraint.identifier == identifier {
                result = constraint
                break
            }
        }
        if result == nil && createIfNotExists {
            // create and add the constraint
            result = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
            result?.identifier = identifier
            addConstraint(result!)
        }
        return result
    }
    
    // MARK: constraint methods
    
    public func fillParentBounds(_ view: UIView) {
        let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        addConstraints([leading, top, trailing, bottom])
        updateConstraints()
    }
}

extension UIView {
    
    // MARK: rotate animation
    
    func rotateWithDuration(_ duration: TimeInterval, indeterminate: Bool) {
        rotateWithDuration(duration, indeterminate: indeterminate, evanescence: false)
    }
    
    func rotateWithDuration(_ duration: TimeInterval, indeterminate: Bool, evanescence: Bool) {
        let animationKey = "ttAnimation"
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = NSNumber(value: 0 as Float)
        rotation.toValue = NSNumber(value: Double.pi)
        rotation.isCumulative = true
        
        if evanescence {
            let alpha = CABasicAnimation(keyPath: "opacity")
            alpha.fromValue = NSNumber(value: 0 as Int32)
            alpha.toValue = NSNumber(value: 1 as Int32)
            alpha.isCumulative = true
            let group = CAAnimationGroup()
            group.duration = duration
            group.repeatCount = indeterminate ? MAXFLOAT : 1
            group.autoreverses = true
            group.animations = [rotation, alpha]
            layer.add(group, forKey: animationKey)
        } else {
            rotation.repeatCount = indeterminate ? MAXFLOAT : 1
            rotation.isRemovedOnCompletion = false
            layer.add(rotation, forKey: animationKey)
        }
        
        if !indeterminate {
            Utils.delay(Int(duration), runnable: {
                self.layer.removeAnimation(forKey: animationKey)
            })
        }
    }
}

extension UIView {
    
    // MARK: gradient methods
    
    public enum GradientDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    public func gradientBackground(_ startColor: UIColor?, _ centerColor: UIColor?, _ endColor: UIColor?, _ direction: GradientDirection) -> CAGradientLayer? {
        guard !(self is UILabel) else {
            Exception("Gradient background cannot be set to labels")
            return nil
        }
        if startColor != nil && endColor != nil {
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            if centerColor != nil {
                gradient.colors = [startColor!.cgColor, centerColor!.cgColor, endColor!.cgColor]
            } else {
                gradient.colors = [startColor!.cgColor, endColor!.cgColor]
            }
            switch direction {
                case .leftToRight:
                    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
                case .rightToLeft:
                    gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
                    gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
                case .topToBottom:
                    gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
                    gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
                case .bottomToTop:
                    gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
                    gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
            }
            layer.insertSublayer(gradient, at: 0)
            return gradient
        } else {
            Logger.e("Trying to set a gradient with a null color")
            return nil
        }
    }
}
