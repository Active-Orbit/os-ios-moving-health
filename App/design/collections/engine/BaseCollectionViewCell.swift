//
//  BaseCollectionViewCell.swift
//  BaseApp
//
//  Created by Omar Brugna on 12/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

open class BaseCollectionViewCell: UICollectionViewCell {
    
    fileprivate var containerView: UIView!
    public var clickListener: (() -> Void)?
    
    open func getXibName() -> String {
        // override to customize
        Exception("Called method in base cell class")
        return Constants.EMPTY
    }
    
    // MARK: init methods
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    fileprivate func prepare() {
        let xibName = getXibName()
        containerView = loadXib(name: xibName, inView: contentView)
        fillParentBounds(containerView)
        selectableBackground()
        onViewPrepared()
    }
    
    fileprivate func selectableBackground() {
        selectedBackgroundView = getBackgroundSelected()
        backgroundView = getBackground()
    }
    
    open func getBackground() -> UIView? {
        let backgroundView = UIView()
        backgroundView.backgroundColor = ColorProvider.get("colorTransparent")
        return backgroundView
    }
    
    open func getBackgroundSelected() -> UIView? {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = ColorProvider.get("colorPrimaryLight")
        return selectedBackgroundView
    }
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        // this method has been overridden because the real fitting size
        // of a collection view cell is the container view content size
        return containerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
    open func onViewPrepared() {
        // override to customize
    }
    
    public func onClick() {
        clickListener?()
    }
}
