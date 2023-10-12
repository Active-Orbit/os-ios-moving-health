//
//  BaseComponent.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//

import UIKit

open class BaseComponent: BaseView {
    
    open func getXibName() -> String {
        // override to customize
        Exception("Called method in base component class")
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
        let xib = getXibName()
        let view = loadXib(name: xib)
        fillParentBounds(view)
        onViewPrepared()
    }
    
    open func onViewPrepared() {
        // override to customize
    }
}
