//
//  BroadcastUtils.swift
//  App
//
//  Created by Omar Brugna on 26/04/21.
//  Copyright © 2021 Active Orbit. All rights reserved.
//

import Foundation

open class BroadcastUtils {
    
    public static func registerReceiver(_ observer: AnyObject, selector: Selector, type: String) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(rawValue: type), object: nil)
    }
    
    public static func unregisterReceiver(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    public static func sendBroadcast(_ key: String, object: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: key), object: object, userInfo: userInfo)
    }
}
