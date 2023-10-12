//
//  DeviceUtils.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

/**
 * Utility class that provides some useful methods to get device information
 */
public class DeviceUtils {
    
    public static func getDeviceName() -> String? {
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let deviceName: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return deviceName
    }
    
    public static func getDeviceOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
}
