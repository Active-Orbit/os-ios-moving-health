//
//  PagerIndicator.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

open class PagerIndicator: UIView {
    
    fileprivate var items = [BaseView]()
    fileprivate var mHorizontalConstraint: NSLayoutConstraint!
    
    fileprivate let horizontalSpace = CGFloat(10)
    fileprivate let itemSize = CGFloat(12)
    
    fileprivate var idleColor = ColorProvider.get("colorGray")
    fileprivate var selectedColor = ColorProvider.get("colorAccent")
    
    var selectedIndex = Constants.INVALID
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //MARK: setup methods
    
    var numberOfItems: Int = 0 {
        didSet {
            removeAllItems()
            for _ in 0..<numberOfItems {
                addItem()
            }
        }
    }
    
    //MARK: utility methods
    
    func addItem() {
        let item = BaseView(frame: CGRect(x: 0, y: 0, width: itemSize, height: itemSize))
        item.rounded()
        item.clipsToBounds = true
        item.backgroundColor = idleColor
        item.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(item)
        
        let widthConstraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: itemSize)
        let heightConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: itemSize)
        let verticalConstraint = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        let horizontalConstraint: NSLayoutConstraint!
        if items.count == 0 {
            horizontalConstraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            mHorizontalConstraint = horizontalConstraint
        } else {
            horizontalConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: items[items.count - 1], attribute: .trailing, multiplier: 1, constant: horizontalSpace)
            mHorizontalConstraint.constant -= (horizontalSpace / 2 + itemSize / 2)
        }
        
        addConstraints([widthConstraint, heightConstraint, verticalConstraint, horizontalConstraint])
        
        items.append(item)
        
        if items.count == 1 {
            // default
            Utils.delay(200, runnable: {
                self.selectItemAtIndex(0)
            })
        }
    }
    
    func removeAllItems() {
        for _ in items {
            removeItem()
        }
        mHorizontalConstraint = nil
        selectedIndex = Constants.INVALID
    }
    
    func removeItem() {
        items.removeLast().removeFromSuperview()
        mHorizontalConstraint.constant += (horizontalSpace / 2 + itemSize / 2)
        updateConstraintsIfNeeded()
    }
    
    func selectItemAtIndex(_ index: Int) {
        if index >= 0 && index < items.count && index != selectedIndex {
            if selectedIndex != Constants.INVALID {
                items[selectedIndex].backgroundColor = idleColor
            }
            items[index].backgroundColor = selectedColor
            selectedIndex = index
        }
    }
}
