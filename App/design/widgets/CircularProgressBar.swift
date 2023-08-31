//
//  CircularProgressBar.swift
//  App
//
//  Created by Omar Brugna on 27/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

open class CircularProgressBar: UIView {
    
    var mAngleStart = ANGLE_START
    var mAngleEnd = ANGLE_END
    var mAngleProgress = ANGLE_PROGRESS
    
    static let ANGLE_START = CGFloat(-90)
    static let ANGLE_END = CGFloat(360)
    static let ANGLE_PROGRESS = CGFloat(0)
    static let FULL_CIRCLE = CGFloat(360)
    
    fileprivate var lastProgressRatio = CGFloat(Constants.INVALID)
    
    var mProgress = CGFloat(0)
    var mMaxProgress = CGFloat(100)
    
    var progressAnimationDuration = Constants.ANIMATION_DURATION_CIRCLE
    
    var mLineWidth = CGFloat(40)
    fileprivate var mTextColor = ColorProvider.get("colorAccent")
    fileprivate var mBackgroundLineColor = ColorProvider.get("colorPrimaryLight")
    fileprivate var mProgressLineColor = ColorProvider.get("colorAccent")
    
    fileprivate var borderLineColor = ColorProvider.get("colorAccent")
    fileprivate var progressLineColor = ColorProvider.get("colorAccent")
    
    fileprivate var progressIconAdded = false
    fileprivate var mProgressIconResource = "ic_activity"
    
    fileprivate var progressIcon = BaseImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    fileprivate var progressIconSize = CGFloat(30)
    fileprivate var progressIconCircleLayer: CAShapeLayer?
    fileprivate var progressIconImageLayer: CALayer?
    
    fileprivate var hideProgressIcon = true
    
    fileprivate var progressIconAngleProgress = CGFloat(0)
    
    var requiredAnimation = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    open func prepare() {
        rounded()
    }
    
    func progress() -> CGFloat {
        return mProgress
    }

    func maxProgress() -> CGFloat {
        return mMaxProgress
    }
    
    func setProgress(_ progress: CGFloat) {
        let newProgressRatio = progress / mMaxProgress
        if lastProgressRatio != newProgressRatio {
            lastProgressRatio = newProgressRatio
            mProgress = progress
            mAngleProgress = getAngleFromProgress()
            requiredAnimation = true
            invalidate()
        }
    }

    func setMaxProgress(_ progressMax: CGFloat) {
        if mMaxProgress <= 0 { Exception("The max progress must be greater than zero") }
        if mMaxProgress != progressMax {
            mMaxProgress = progressMax
            requiredAnimation = true
            invalidate()
        }
    }

    func setBackgroundLineColor(_ color: UIColor?, forceInvalidate: Bool = false) {
        mBackgroundLineColor = color
        if forceInvalidate {
            requiredAnimation = true
            invalidate()
        }
    }

    func setProgressLineColor(_ color: UIColor?, forceInvalidate: Bool = false) {
        mProgressLineColor = color
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
    
    open override func draw(_ rect: CGRect) {
        clear()
        
        if mProgress <= 100 {
            progressAnimationDuration = Constants.ANIMATION_DURATION_CIRCLE
        } else {
            progressAnimationDuration = Constants.ANIMATION_DURATION_CIRCLE * Double((mProgress / CGFloat(150)))
        }
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let diameter = min(bounds.width, bounds.height) - mLineWidth / 2
        
        drawBackground(rect, center, diameter)
        drawProgress(rect, center, diameter)
        
        progressIconAngleProgress = getAngleFromProgress()
        
        if !hideProgressIcon {
            addProgressIcon(diameter)
        }
    }
    
    func getAngleFromProgress() -> CGFloat {
        return mAngleEnd / mMaxProgress * mProgress
    }
    
    func clear() {
        layer.sublayers?.forEach({
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        })
    }
    
    func reset() {
        mAngleStart = CircularProgressBar.ANGLE_START
        mAngleEnd = CircularProgressBar.ANGLE_END
        mAngleProgress = CircularProgressBar.ANGLE_PROGRESS
    }
    
    func drawBackground(_ rect: CGRect, _ center: CGPoint, _ diameter: CGFloat) {
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: diameter / 2, startAngle: mAngleStart.degreesToRadians, endAngle: (mAngleEnd + mAngleStart).degreesToRadians, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.init(white: 1, alpha: 0).cgColor
        shapeLayer.strokeColor = mBackgroundLineColor?.cgColor
        shapeLayer.lineWidth = mLineWidth
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
    }
    
    func drawProgress(_ rect: CGRect, _ center: CGPoint, _ diameter: CGFloat) {
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: diameter / 2, startAngle: mAngleStart.degreesToRadians, endAngle: (mAngleProgress + mAngleStart).degreesToRadians, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.init(white: 1, alpha: 0).cgColor
        shapeLayer.strokeColor = mProgressLineColor?.cgColor
        shapeLayer.lineWidth = mLineWidth
        shapeLayer.contents = ImageProvider.get("ic_progress_heart")?.cgImage
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
        
        if requiredAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fillMode = .backwards
            animation.fromValue = 0
            animation.timingFunction = Constants.ANIMATION_TYPE_CIRCLE
            animation.duration = progressAnimationDuration
            animation.beginTime = CACurrentMediaTime()
            shapeLayer.add(animation, forKey: "ProgressAnimation")
        }
        
        requiredAnimation = false
    }
    
    fileprivate func addProgressIcon(_ diameter: CGFloat) {
        let circleRadius = diameter / 2
        let thumbRadius = progressIconSize / 2
        let circleCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // this is an invisible circular layer that will rotate to get the illusion of the circular progress attached icon
        progressIconCircleLayer = CAShapeLayer()
        progressIconCircleLayer!.fillColor = nil
        progressIconCircleLayer!.strokeColor = nil
        progressIconCircleLayer!.lineWidth = 4
        progressIconCircleLayer!.path = CGPath(ellipseIn: CGRect(x: -circleRadius, y: -circleRadius, width: 2 * circleRadius, height: 2 * circleRadius), transform: nil)
        progressIconCircleLayer!.position = circleCenter
        layer.addSublayer(progressIconCircleLayer!)
        
        let progressIconImage = ImageProvider.get(mProgressIconResource)?.cgImage
        progressIconImageLayer = CALayer()
        progressIconImageLayer!.frame = CGRect(x: -thumbRadius, y: -circleRadius - thumbRadius, width: 2 * thumbRadius, height: 2 * thumbRadius)
        progressIconImageLayer!.contents = progressIconImage
        progressIconCircleLayer!.addSublayer(progressIconImageLayer!)
        
        // rotate the invisible circle layer to move the progress icon
        let animationCircle = CABasicAnimation(keyPath: "transform.rotation")
        animationCircle.fillMode = .forwards
        animationCircle.toValue = progressIconAngleProgress.degreesToRadians
        animationCircle.timingFunction = Constants.ANIMATION_TYPE_CIRCLE
        animationCircle.isAdditive = true
        animationCircle.beginTime = CACurrentMediaTime()
        animationCircle.isRemovedOnCompletion = false
        progressIconCircleLayer?.add(animationCircle, forKey: "ProgressCircleAnimation")
        
        // rotate the progress icon in the reverse way to keep it straight ahead
        let animationImage = CABasicAnimation(keyPath: "transform.rotation")
        animationImage.fillMode = .forwards
        animationImage.toValue = -progressIconAngleProgress.degreesToRadians
        animationImage.timingFunction = Constants.ANIMATION_TYPE_CIRCLE
        animationImage.isAdditive = true
        animationImage.beginTime = CACurrentMediaTime()
        animationImage.isRemovedOnCompletion = false
        progressIconImageLayer?.add(animationImage, forKey: "ProgressImageAnimation")
        
        if requiredAnimation {
            animationCircle.fromValue = 0
            animationCircle.duration = progressAnimationDuration
            animationImage.fromValue = 0
            animationImage.duration = progressAnimationDuration
        } else {
            // fake animation
            animationCircle.fromValue = progressIconAngleProgress.degreesToRadians
            animationCircle.duration = 0
            animationImage.fromValue = -progressIconAngleProgress.degreesToRadians
            animationImage.duration = 0
        }
        
        progressIconCircleLayer?.add(animationCircle, forKey: "ProgressCircleAnimation")
        progressIconImageLayer?.add(animationImage, forKey: "ProgressImageAnimation")
        
        requiredAnimation = false
    }
}
