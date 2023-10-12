//
//  LineView.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//

import UIKit

class LineView: UIView {
    
    fileprivate var progress: Int = 0
    
    fileprivate var borderLineColor = ColorProvider.get("white")
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
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: bounds.size.width, y: bounds.size.height)
        let endProgress = CGPoint(x: CGFloat(progress) * bounds.size.width / 100, y: bounds.size.height)
        
        let borderLinePath = UIBezierPath(rect: CGRect(x: start.x, y: start.y, width: end.x, height: end.y))
        borderLineColor?.setFill()
        borderLinePath.fill()
        
        let progressLinePath = UIBezierPath(rect: CGRect(x: start.x, y: start.y, width: endProgress.x, height: endProgress.y))
        progressLineColor?.setFill()
        progressLinePath.fill()
    }
}
