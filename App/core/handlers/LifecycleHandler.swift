//
//  LifecycleHandler.swift
//  App
//
//  Created by Omar Brugna on 31/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

public class LifecycleHandler {
    
    public static let instance = LifecycleHandler()
    public static var currentController: BaseController?
    
    /**
     * Check if application is in foreground or in background
     *
     * @return true, if application is in foreground
     */
    public static var isApplicationInForeground = false {
        didSet {
            if isApplicationInForeground {
                if currentController != nil {
                    // notify application in foreground
                    BaseBroadcast.notifyApplicationForeground(currentController!)
                }
            }
        }
    }
}

extension LifecycleHandler {
    
    public func onControllerCreated(_ controller: BaseController?, savedInstanceState: Boundle?) {}
    
    public func onControllerStarted(_ controller: BaseController?) {}
    
    public func onControllerResumed(_ controller: BaseController?) {
        if !(controller is SideMenuController) {
            LifecycleHandler.currentController = controller
        }
    }
    
    public func onControllerPaused(_ controller: BaseController?) { }
    
    public func onControllerStopped(_ controller: BaseController?) {}
    
    public func onControllerSaveInstanceState(_ controller: BaseController?, _ outState: Boundle?) {}
    
    public func onControllerDestroyed(_ controller: BaseController?) {}
}
