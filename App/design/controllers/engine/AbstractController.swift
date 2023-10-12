//
//  AbstractController.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

/**
 * Abstract controller that exposes useful methods
 */
open class AbstractController : UIViewController {
    
    fileprivate var firstWillAppear = true
    fileprivate var firstDidAppear = true
    
    fileprivate var navigationBarVisible = true
    fileprivate var backButtonEnabled = false
    fileprivate var backSwipeEnabled = false
    fileprivate var backButtonCustomImage: UIImage?
    
    fileprivate static var identifierCount = 0
    fileprivate let identifier = identifierCount + 1
    fileprivate var mBroadcasts = [BaseBroadcast]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // fix for navigation bar black space
        navigationController?.view.backgroundColor = ColorProvider.get("colorBackground")
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.visibility = navigationBarVisible ? .visible : .invisible
        
        if firstWillAppear {
            firstWillAppear = false
            viewFirstWillAppear()
        } else {
            onUpdate()
        }
    }
    
    open func viewFirstWillAppear() {
        if backButtonCustomImage != nil {
            (navigationController as? BaseNavigationController)?.backSwipeEnabled = false
            navigationItem.hidesBackButton = true
            showNavigationBarIconLeft(image: backButtonCustomImage!, isBackButton: true)
        } else {
            (navigationController as? BaseNavigationController)?.backSwipeEnabled = backSwipeEnabled
            navigationItem.hidesBackButton = !backButtonEnabled
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.EMPTY, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        if firstDidAppear {
            firstDidAppear = false
            viewFirstDidAppear()
        }
    }
    
    open func viewFirstDidAppear() {
        // override to customize
    }
    
    open func onUpdate() {
        
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        onDestroy()
        super.dismiss(animated: flag, completion: completion)
    }
    
    deinit {
        // seems to be called only sometimes
        onDestroy()
    }
    
    open func onDestroy() {
        broadcastUnregister()
    }
    
    // MARK: navigation bar methods
    
    public func setNavigationBarTitle(string: String?) {
        navigationItem.title = string
    }
    
    public func hideNavigationBar() {
        navigationBarVisible = false
    }
    
    public func showNavigationBar() {
        navigationBarVisible = true
    }
    
    public func showBackButton() {
        backButtonEnabled = true
    }
    
    public func showBackButtonCustomImage(_ image: UIImage?) {
        backButtonCustomImage = image
    }
    
    public func showBackSwipe() {
        backSwipeEnabled = true
    }
    
    public func finish(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    // MARK: navigation icon right methods
    
    public func showNavigationBarIconRight(image: UIImage?) {
        guard image != nil else {
            Logger.e("Navigation bar icon right image is null")
            return
        }
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: DimensionProvider.NAVIGATION_BAR_ICON_SIZE, height: DimensionProvider.NAVIGATION_BAR_ICON_SIZE)
        button.addTarget(self, action: #selector(self.onNavigationBarIconRightClicked(_:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let resizedImage = ImageUtils.resizeImage(image!, DimensionProvider.NAVIGATION_BAR_ICON_SIZE)
        button.setImage(resizedImage, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    public func hideNavigationBarIconRight() {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc fileprivate func onNavigationBarIconRightClicked(_ sender: UIButton) {
        onNavigationBarIconRightClicked()
    }
    
    open func onNavigationBarIconRightClicked() {
        // override to customize
    }
    
    // MARK: navigation icon left methods
    
    public func showNavigationBarIconLeft(image: UIImage?, isBackButton: Bool = false) {
        guard image != nil else {
            Logger.e("Navigation bar icon left image is null")
            return
        }
        let button = UIButton(type: .custom)
        if isBackButton {
            button.frame = CGRect(x: 0, y: 0, width: DimensionProvider.NAVIGATION_BAR_BACK_BUTTON_SIZE, height: DimensionProvider.NAVIGATION_BAR_BACK_BUTTON_SIZE)
            button.addTarget(self, action: #selector(self.onBackPressed(_:)), for: .touchUpInside)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let resizedImage = ImageUtils.resizeImage(image!, DimensionProvider.NAVIGATION_BAR_BACK_BUTTON_SIZE)
            button.setImage(resizedImage, for: .normal)
        } else {
            button.frame = CGRect(x: 0, y: 0, width: DimensionProvider.NAVIGATION_BAR_ICON_SIZE, height: DimensionProvider.NAVIGATION_BAR_ICON_SIZE)
            button.addTarget(self, action: #selector(self.onNavigationBarIconLeftClicked(_:)), for: .touchUpInside)
            button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            let resizedImage = ImageUtils.resizeImage(image!, DimensionProvider.NAVIGATION_BAR_ICON_SIZE)
            button.setImage(resizedImage, for: .normal)
        }
        let buttonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItems = [buttonItem]
    }
    
    public func hideNavigationBarIconLeft() {
        navigationItem.leftBarButtonItems = nil
    }
    
    @objc fileprivate func onNavigationBarIconLeftClicked(_ sender: UIButton) {
        onNavigationBarIconLeftClicked()
    }
    
    open func onNavigationBarIconLeftClicked() {
        // override to customize
    }
    
    @objc fileprivate func onBackPressed(_ sender: UIButton) {
        onBackPressed()
    }
    
    open func onBackPressed() {
        finish()
    }
    
    // MARK: keyboard methods
    
    public func hideKeyboard() {
        view.hideKeyboard()
    }
    
    public func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrameNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    public func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc final func keyboardWillShowNotification(_ notification: Notification) {
        keyboardWillShow(getKeyboardFrame(notification))
    }
    
    @objc final func keyboardWillHideNotification(_ notification: Notification) {
        keyboardWillHide(getKeyboardFrame(notification))
    }
    
    @objc final func keyboardWillChangeFrameNotification(_ notification: Notification) {
        keyboardWillChangeFrame(getKeyboardFrame(notification))
    }
    
    fileprivate func getKeyboardFrame(_ notification: Notification) -> CGRect {
        let userInfo = notification.userInfo
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
    }
    
    open func keyboardWillShow(_ keyboardFrame: CGRect) {
        // override to customize
    }
    
    open func keyboardWillHide(_ keyboardFrame: CGRect) {
        // override to customize
    }
    
    open func keyboardWillChangeFrame(_ keyboardFrame: CGRect) {
        // override to customize
    }
}

extension AbstractController: BroadcastHost {
    
    public func broadcastRegister(_ broadcast: BaseBroadcast) {
        mBroadcasts.append(broadcast)
    }
    
    public func broadcastUnregister() {
        for broadcast in mBroadcasts {
            broadcast.unregister()
        }
        mBroadcasts.removeAll()
    }
    
    public func broadcastIdentifier() -> Int {
        return identifier
    }
    
    public func isBroadcastRegistered() -> Bool {
        return !mBroadcasts.isEmpty
    }
}
