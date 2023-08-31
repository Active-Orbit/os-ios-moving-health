//
//  HorizontalProgressBar.swift
//  App
//
//  Created by George Stavrou on 12/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class HorizontalProgressBar: BaseView {
    
    fileprivate var lastProgressRatio = CGFloat(Constants.INVALID)
    
    var mProgress = CGFloat(0)
    var mMaxProgress = CGFloat(100)
    
    fileprivate var mLineWidth = CGFloat(35)
    
    fileprivate var mProgressIconResource = "ic_activity"
    fileprivate var progressIcon = BaseImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    fileprivate var progressIconSize = CGFloat(30)
    fileprivate var progressIconLayer: CALayer?
    
    fileprivate var mBackgroundLineColorOne = ColorProvider.get("colorPrimaryLight")
    fileprivate var mBackgroundLineColorTwo = ColorProvider.get("colorPrimaryLight")
    fileprivate var mProgressLineColorOne = ColorProvider.get("colorAccent")
    fileprivate var mProgressLineColorTwo = ColorProvider.get("colorAccent")
        
    private var counter: CGFloat = 1
    
    fileprivate var requiredAnimation = false
    fileprivate var repeatedAnimation = false
    
    fileprivate var hideProgressIcon = false
    
    func progress() -> CGFloat {
        return mProgress
    }
    
    func maxProgress() -> CGFloat {
        return mMaxProgress
    }
    
    fileprivate func getProgress() -> CGFloat {
        return layer.bounds.width / mMaxProgress * mProgress
    }
    
    func setProgress(_ progress: CGFloat, _ runRepeated: Bool = false) {
        let newProgressRatio = progress / mMaxProgress
        if lastProgressRatio != newProgressRatio {
            lastProgressRatio = newProgressRatio
            mProgress = progress
            requiredAnimation = true
            repeatedAnimation = runRepeated
            invalidate()
        }
    }
    
    func setMaxProgress(_ maxProgress: CGFloat, forceInvalidate: Bool = false) {
        mMaxProgress = maxProgress
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    func setBackgroundLineColorOne(_ color: UIColor?, forceInvalidate: Bool = false) {
        mBackgroundLineColorOne = color
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    func setBackgroundLineColorTwo(_ color: UIColor?, forceInvalidate: Bool = false) {
        mBackgroundLineColorTwo = color
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    func setProgressLineColorOne(_ color: UIColor?, forceInvalidate: Bool = false) {
        mProgressLineColorOne = color
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    func setProgressLineColorTwo(_ color: UIColor?, forceInvalidate: Bool = false) {
        mProgressLineColorTwo = color
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    func setLineWidth(_ width: CGFloat, forceInvalidate: Bool = false) {
        mLineWidth = width
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    func setProgressIconResource(_ resourceId: String, forceInvalidate: Bool = false) {
        mProgressIconResource = resourceId
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    func hideProgressIcon(forceInvalidate: Bool = false) {
        hideProgressIcon = true
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }
    
    override func draw(_ rect: CGRect) {
        clear()
        drawBackground(rect)
        
        layer.masksToBounds = true
        
        if mProgress > CGFloat(0) {
            drawProgress(rect)
        }
    }
    
    func clear() {
        layer.sublayers?.forEach({
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        })
    }
    
    fileprivate func drawBackground(_ rect: CGRect) {
        let backgroundLayer = CAGradientLayer()
        backgroundLayer.frame = CGRect(origin: .zero, size: CGSize(width: rect.width, height: rect.height))
        backgroundLayer.cornerRadius = rect.height / 2
        backgroundLayer.colors = [mBackgroundLineColorOne?.cgColor as Any, mBackgroundLineColorTwo?.cgColor as Any]
        backgroundLayer.type = .axial
        backgroundLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        backgroundLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.addSublayer(backgroundLayer)
    }
    
    fileprivate func drawProgress(_ rect: CGRect) {
        
        let lineHeight = rect.height
        let pointStart = CGPoint(x: 0, y: lineHeight / 2)
        let pointEnd = CGPoint(x: getProgress(), y: lineHeight / 2)
        
        let maskPath = UIBezierPath()
        maskPath.move(to: pointStart)
        maskPath.addLine(to: pointEnd)
        
        // gradient mask
        let gradientMask = CAShapeLayer()
        gradientMask.frame = CGRect(origin: .zero, size: CGSize(width: getProgress(), height: lineHeight))
        gradientMask.cornerRadius = lineHeight / 2
        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.strokeColor = UIColor.black.cgColor
        gradientMask.lineWidth = lineHeight
        gradientMask.path = maskPath.cgPath
        
        // progress gradient layer
        let progressLayer = CAGradientLayer()
        progressLayer.frame = CGRect(origin: .zero, size: CGSize(width: getProgress(), height: lineHeight))
        progressLayer.cornerRadius = lineHeight / 2
        progressLayer.colors = [mProgressLineColorOne?.cgColor as Any, mProgressLineColorTwo?.cgColor as Any]
        progressLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        progressLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        progressLayer.mask = gradientMask
        layer.addSublayer(progressLayer)
        
        if requiredAnimation {
            
            let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            progressAnimation.fromValue = 0
            progressAnimation.duration = Constants.ANIMATION_DURATION_HORIZONTAL
            progressAnimation.beginTime = CACurrentMediaTime()
            progressAnimation.timingFunction = Constants.ANIMATION_TYPE_HORIZONTAL
            progressAnimation.fillMode = .backwards
            progressAnimation.isRemovedOnCompletion = false
            if repeatedAnimation {
                progressAnimation.repeatCount = 10000
            }
            gradientMask.add(progressAnimation, forKey: "HorizontalAnimation")
        }
            
        progressIconLayer?.removeFromSuperlayer()
        
        if mProgress > 0 {
            
            if !hideProgressIcon {
                addProgressIconLayer()
            }
            
            let iconStartPoint = CGPoint(x: getProgressIconFrame(0).midX, y: getProgressIconFrame(0).midY)
            let iconEndPoint = CGPoint(x: getProgressIconFrame(1).midX, y: getProgressIconFrame(100).midY)
            
            progressIconLayer?.position = iconEndPoint
            
            if requiredAnimation {
                let iconAnimation = CABasicAnimation(keyPath: "position")
                iconAnimation.fromValue = NSValue(cgPoint: iconStartPoint)
                iconAnimation.toValue = NSValue(cgPoint: iconEndPoint)
                iconAnimation.duration = Constants.ANIMATION_DURATION_HORIZONTAL
                iconAnimation.beginTime = CACurrentMediaTime()
                iconAnimation.timingFunction = Constants.ANIMATION_TYPE_HORIZONTAL
                iconAnimation.fillMode = .backwards
                iconAnimation.isRemovedOnCompletion = false
                if repeatedAnimation {
                    iconAnimation.repeatCount = 10000
                }
                progressIconLayer?.add(iconAnimation, forKey: "IconAnimation")
            }
        }
        
        requiredAnimation = false
    }
    
    fileprivate func getProgressIconFrame(_ percentage: CGFloat) -> CGRect {
        let totalWidth = getProgress() * percentage
        let coordinateX = max(layer.bounds.origin.x - progressIconSize - 8, totalWidth - progressIconSize - 8)
        let coordinateY = mLineWidth / 4 - 6
        let progressIconFrame = CGRect(x: coordinateX, y: coordinateY, width: progressIconSize, height: progressIconSize)
        return progressIconFrame
    }
    
    fileprivate func addProgressIconLayer() {
        let progressIconImage = ImageProvider.get(mProgressIconResource)?.cgImage
        let progressIconFrame = getProgressIconFrame(0)
        progressIconLayer = CALayer()
        progressIconLayer!.frame = progressIconFrame
        progressIconLayer!.contents = progressIconImage
        layer.addSublayer(progressIconLayer!)
    }
}
