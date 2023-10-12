//
//  BaseNavigationController.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

public class BaseNavigationController: UINavigationController {
    
    public var backSwipeEnabled: Bool {
        set {
            interactivePopGestureRecognizer?.isEnabled = newValue
        }
        get {
            return interactivePopGestureRecognizer?.isEnabled ?? true
        }
    }
    
    override public func viewDidLoad() {
        navigationBar.isTranslucent = false
    }
    
    public func setToolbarAttributes(toolbarBackground: UIColor?, titleColor: UIColor?, titleFont: UIFont) {
        navigationBar.tintColor = titleColor
        navigationBar.barTintColor = toolbarBackground
        
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.foregroundColor] = titleColor
        attributes[NSAttributedString.Key.font] = titleFont
        navigationBar.titleTextAttributes = attributes
    
        setOpaqueBackground(toolbarBackground)
    }
    
    fileprivate func setOpaqueBackground(_ color: UIColor?) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }
    
    // MARK: custom pop methods
    
    func viewControllerOfType(_ classForCoder: AnyClass) -> BaseController? {
        for controller in viewControllers {
            if controller.classForCoder == classForCoder {
                return controller as? BaseController
            }
        }
        return nil
    }
    
    func popToViewControllerOfType(_ classForCoder: AnyClass) -> Bool {
        for controller in viewControllers {
            if controller.classForCoder == classForCoder {
                popToViewController(controller, animated: true)
                return true
            }
        }
        return false
    }
    
    func popViewControllers(_ controllersToPop: Int, animated: Bool) {
        if viewControllers.count > controllersToPop {
            popToViewController(viewControllers[viewControllers.count - (controllersToPop + 1)], animated: animated)
        } else {
            Logger.e("Trying to pop \(controllersToPop) view controllers but navigation controller contains only \(viewControllers.count) controllers in stack")
        }
    }
}
