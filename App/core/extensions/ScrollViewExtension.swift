//
//  ScrollViewExtension.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

extension UIScrollView {
    
    public var contentInsetTop: CGFloat {
        get {
            return contentInset.top
        }
        set {
            contentInset = UIEdgeInsets(top: newValue, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
        }
    }
    
    public var contentInsetLeft: CGFloat {
        get {
            return contentInset.left
        }
        set {
            contentInset = UIEdgeInsets(top: contentInset.top, left: newValue, bottom: contentInset.bottom, right: contentInset.right)
        }
    }
    
    public var contentInsetBottom: CGFloat {
        get {
            return contentInset.bottom
        }
        set {
            contentInset = UIEdgeInsets(top: contentInset.top, left: contentInset.left, bottom: newValue, right: contentInset.right)
        }
    }
    
    public var contentInsetRight: CGFloat {
        get {
            return contentInset.right
        }
        set {
            contentInset = UIEdgeInsets(top: contentInset.top, left: contentInset.left, bottom: contentInset.bottom, right: newValue)
        }
    }
    
    public var minContentOffset: CGPoint {
        return CGPoint(
            x: -contentInset.left,
            y: -contentInset.top)
    }
    
    public var maxContentOffset: CGPoint {
        return CGPoint(
            x: contentSize.width - bounds.width + contentInset.right,
            y: contentSize.height - bounds.height + contentInset.bottom)
    }
    
    public func scrollToPoint(_ point: CGPoint, _ animated: Bool = true) {
        var scrollX = point.x
        var scrollY = point.y
        scrollX = min(scrollX, maxContentOffset.x)
        scrollY = min(scrollY, maxContentOffset.y)
        scrollX = max(scrollX, minContentOffset.x)
        scrollY = max(scrollY, minContentOffset.y)
        
        let offset = CGPoint(x: scrollX, y: scrollY)
        setContentOffset(offset, animated: animated)
    }
    
    public func scrollToView(_ view: UIView, _ animated: Bool) {
        if superview != nil {
            let childStartPoint = superview!.convert(view.frame.origin, to: self)
            let rect = CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height)
            self.scrollRectToVisible(rect, animated: animated)
        }
    }
    
    func scrollToTop(_ animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    func scrollToBottom(_ animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}
