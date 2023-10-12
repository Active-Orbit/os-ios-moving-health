//
//  CircleView.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

class CircleView: UIView {
    
    fileprivate var lineWidth: CGFloat = 2
    fileprivate var progress: Int = 0
    
    fileprivate static let fullCircle = CGFloat(Double.pi) * 2
    fileprivate static let startAngle = CGFloat(Double.pi * 3 / 2)
    fileprivate static let endAngle = startAngle + fullCircle
    
    fileprivate var borderLineColor = ColorProvider.get("colorRouteDefault")
    fileprivate var progressLineColor = ColorProvider.get("colorAccent")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    fileprivate func initialize() {
        rounded()
    }
    
    public func setLineWidth(_ value: CGFloat) {
        lineWidth = value
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    public func setProgress(_ value: Int) {
        progress = value
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    public func setBorderlineColor(_ value: UIColor?) {
        borderLineColor = value
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    public func setProgresslineColor(_ value: UIColor?) {
        progressLineColor = value
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = CGFloat(bounds.width / 2 - (lineWidth / 2))
        
        let borderLinePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CircleView.startAngle, endAngle: CircleView.endAngle, clockwise: true)
        borderLinePath.lineWidth = lineWidth
        borderLineColor?.setStroke()
        borderLinePath.stroke()
        
        let progressLinePath = UIBezierPath(arcCenter: center, radius: radius,  startAngle:CircleView.startAngle, endAngle: (CircleView.endAngle - CircleView.startAngle) * CGFloat(Double(progress) / 100.0) + CircleView.startAngle , clockwise: true)
        progressLinePath.lineWidth = lineWidth
        progressLineColor?.setStroke()
        progressLinePath.stroke()
    }
}
