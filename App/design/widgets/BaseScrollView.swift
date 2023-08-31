//
//  BaseScrollView.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import UIKit

public class BaseScrollView: UIScrollView, UIScrollViewDelegate {
    
    fileprivate static let MIN_ZOOM: CGFloat = 1
    fileprivate static let MAX_ZOOM: CGFloat = 5
    fileprivate static let DOUBLE_TAP_ZOOM: CGFloat = 4
    
    fileprivate var mZoomableView: UIView?
    
    fileprivate var isZoomEnabled = true
    var zoomEnabled = false {
        didSet {
            if !zoomEnabled {
                resetZoom()
            }
            isZoomEnabled = zoomEnabled
        }
    }
    
    public var currentPage: Int {
        set {
            setContentOffset(CGPoint(x: frame.size.width * CGFloat(newValue), y: contentOffset.y), animated: true)
        }
        get {
            return Int((contentOffset.x + (0.5 * frame.size.width)) / frame.width)
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
        delaysContentTouches = true
        canCancelContentTouches = true
    }
    
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    
    fileprivate func resetZoom() {
        setZoomScale(BaseScrollView.MIN_ZOOM, animated: true)
    }
    
    public func enableZoom(_ zoomableView: UIView) {
        mZoomableView = zoomableView
        
        minimumZoomScale = BaseScrollView.MIN_ZOOM
        maximumZoomScale = BaseScrollView.MAX_ZOOM
        delegate = self
        
        // zoom with double tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapTwice(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
    }
    
    @objc func tapTwice(_ gesture: UIGestureRecognizer) {
        let newScale = zoomScale * BaseScrollView.DOUBLE_TAP_ZOOM
        if zoomScale > minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let zoomRect = zoomRectForScale(newScale, withCenter: gesture.location(in: gesture.view))
            zoom(to: zoomRect, animated: true)
        }
    }
    
    fileprivate func zoomRectForScale(_ scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        // calculate where to zoom on double tap
        var zoomRect = CGRect()
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width  = frame.size.width  / scale
        let newCenter = convert(center, from: self)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return isZoomEnabled ? mZoomableView : nil
    }
}
