//
//  BaseCollectionView.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit
import Tracker

open class BaseCollectionView: UICollectionView {
    
    public var models = [TrackerProtocol]()
    public var controller: BaseController?
    
    public var listener: BaseCollectionListener?
    
    public var lastFrame: CGRect?
    public var fixIntrinsicContentSize = false
    
    public var flowLayout: UICollectionViewFlowLayout? {
        get {
            return collectionViewLayout as? UICollectionViewFlowLayout
        }
    }
    
    public var longPressEnabled: Bool {
        set {
            if newValue {
                enableLongPress()
            }
        }
        get {
            return false
        }
    }
    
    // MARK: system methods
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
        registerCell()
    }
    
    func prepare() {
        delaysContentTouches = false
        canCancelContentTouches = true
        UICollectionView.appearance().backgroundColor = ColorProvider.get("colorTransparent")
        UICollectionViewCell.appearance().backgroundColor = ColorProvider.get("colorTransparent")
    }
    
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    
    // MARK: data methods
    
    open func registerCell() {
        Logger.e("Register cell called in base class")
    }
    
    open func dataSource() -> [TrackerProtocol] {
        return [TrackerProtocol]()
    }
    
    open func onDestroy() {
        // override to customize
    }
    
    // MARK: utility methods
    
    public func getItemCount() -> Int {
        return models.count
    }
    
    public func getItemIndex(_ model: TrackerProtocol?) -> Int {
        var index = 0
        var found = false
        for subModel in models {
            if subModel.identifier() == model?.identifier() {
                found = true
                break
            }
            index += 1
        }
        if found {
            return index
        }
        return Constants.INVALID
    }
    
    // MARK: insert methods
    
    open func addItem(_ model: TrackerProtocol?) {
        if model != nil && model!.isValid() {
            let index = getItemIndex(model)
            if index != Constants.INVALID {
                updateItemAt(index, model!)
            } else {
                addItemAt(models.count, model!)
            }
        }
    }
    
    fileprivate func addItemAt(_ index: Int, _ model: TrackerProtocol) {
        if flowLayout?.scrollDirection == .horizontal {
            models.insert(model, at: index)
            insertSections(IndexSet(integer: index))
        } else {
            models.insert(model, at: index)
            insertItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    // MARK: update methods
    
    open func updateItem(_ model: TrackerProtocol?) {
        if model != nil && model!.isValid() {
            let index = getItemIndex(model)
            if index != Constants.INVALID {
                updateItemAt(index, model!)
            }
        }
    }
    
    fileprivate func updateItemAt(_ index: Int, _ model: TrackerProtocol) {
        models[index] = model
        if flowLayout?.scrollDirection == .horizontal {
            reloadSections(IndexSet(integer: index))
        } else {
            reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    // MARK: reload methods
    
    public func reloadItemAt(_ index: Int) {
        if models.count > index {
            if flowLayout?.scrollDirection == .horizontal {
                reloadSections(IndexSet(integer: index))
            } else {
                reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    public func reloadAll() {
        var indexPaths = [IndexPath]()
        if flowLayout?.scrollDirection == .horizontal {
            for index in 0..<models.count {
                indexPaths.append(IndexPath(item: 0, section: index))
            }
            reloadItems(at: indexPaths)
        } else {
            for index in 0..<models.count {
                indexPaths.append(IndexPath(item: index, section: 0))
            }
            reloadItems(at: indexPaths)
        }
    }
    
    // MARK: delete methods
    
    open func removeItem(_ model: TrackerProtocol?) {
        let index = getItemIndex(model)
        if index != Constants.INVALID {
            removeItemAt(index)
        }
    }
    
    fileprivate func removeItemAt(_ index: Int) {
        models.remove(at: index)
        if flowLayout?.scrollDirection == .horizontal {
            deleteSections(IndexSet(integer: index))
        } else {
            deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    public func removeAll() {
        for _ in 0..<models.count {
            removeItemAt(0)
        }
    }
    
    public func replaceAll(_ models: [TrackerProtocol]) {
        self.models = validate(models)
        reloadData()
    }
    
    fileprivate func validate(_ items: [TrackerProtocol]) -> [TrackerProtocol] {
        var newItems = [TrackerProtocol]()
        for item in items {
            if item.isValid() {
                newItems.append(item)
            } else {
                Logger.w("Found invalid item in data source \(item)")
            }
        }
        return newItems
    }
    
    // MARK: scroll methods
    
    public func scrollToTop() {
        if getItemCount() > 0 {
            if flowLayout?.scrollDirection == .horizontal {
                scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            } else {
                scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    public func scrollToBottom() {
        if getItemCount() > 0 {
            if flowLayout?.scrollDirection == .horizontal {
                scrollToItem(at: IndexPath(item: 0, section: models.count - 1), at: .right, animated: false)
            } else {
                scrollToItem(at: IndexPath(item: models.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    func smoothScrollToTop(_ animated: Bool) {
        if flowLayout?.scrollDirection == .horizontal {
            scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        } else {
            scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func smoothScrollToBottom(_ animated: Bool) {
        if getItemCount() > 0 {
            if flowLayout?.scrollDirection == .horizontal {
                scrollToItem(at: IndexPath(item: 0, section: models.count - 1), at: .right, animated: true)
            } else {
                scrollToItem(at: IndexPath(item: models.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    public func refresh(_ refreshListener: ClosureInt? = nil) {
        let sourceModels = dataSource()
        replaceAll(sourceModels)
        
        if fixIntrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
        
        refreshListener?(sourceModels.count)
    }
    
    // MARK: long press methods
    
    fileprivate func enableLongPress() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gestureReconizer:)))
        longTap.minimumPressDuration = DurationProvider.LONG_PRESS
        longTap.delaysTouchesBegan = true
        addGestureRecognizer(longTap)
    }
    
    @objc fileprivate func onLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            let indexPath = detectIndexPath(gestureReconizer)
            if indexPath != nil {
                listener?.onLongPress(collectionView: self, indexPath: indexPath!)
            } else {
                Logger.w("Could not find index path on long press")
            }
        }
    }
    
    fileprivate func detectIndexPath(_ gestureReconizer: UILongPressGestureRecognizer) -> IndexPath? {
        let point = gestureReconizer.location(in: self)
        return indexPathForItem(at: point)
    }
    
    // MARK: layout methods
    
    public func isMisplaced() -> Bool {
        return lastFrame != nil && lastFrame != frame
    }
    
    open override var intrinsicContentSize: CGSize {
        if fixIntrinsicContentSize {
            return flowLayout?.collectionViewContentSize ?? super.intrinsicContentSize
        }
        return super.intrinsicContentSize
    }
}
