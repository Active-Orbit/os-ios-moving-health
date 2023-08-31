//
//  Utils.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

/**
 * Utility class that provides some general useful methods
 */
public class Utils {
    
    public static func getAppName() -> String? {
        return mainBundle.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    public static func getPackageName() -> String? {
        return mainBundle.bundleIdentifier
    }
    
    public static func getVersionName() -> String? {
        return mainBundle.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public static func getVersionCode() -> String? {
        return mainBundle.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
    
    public static func getPhoneModel() -> String? {
        return UIDevice.current.name
    }
    
    public static func getIosVersion() -> String? {
        return "Ios " + UIDevice.current.systemName + " - " + UIDevice.current.systemVersion
    }
    
    public static func getAppVersion() -> String? {
        return "Ios " + (getVersionName() ?? Constants.EMPTY)
    }
    
    public static func isSimulator() -> Bool {
#if TARGET_IPHONE_SIMULATOR
        return true
#else
        return false
#endif
    }
    
    public static func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    public static func delay(_ milliseconds: Int, runnable: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: runnable)
    }
    
    /**
     * Generate a random number between min and max (included)
     *
     * @param min minimum number
     * @param max maximum number
     * @return the generated random number in range
     */
    public static func randomNumber(_ min: Int, _ max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    /**
     * Generate a random string
     * @return the generated random string
     */
    public static func randomString() -> String {
        return UUID().uuidString
    }
    
    public static func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
    
    public static func getBatteryPercentage() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return Int(UIDevice.current.batteryLevel * 100)
    }
    
    public static func isCharging() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        switch UIDevice.current.batteryState {
            case .charging, .full:
                return true
            default:
                return false
        }
    }
    
    public static func getLocalIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? nil
    }
    
    public static func validateIpAddress(_ ipToValidate: String) -> Bool {
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()
        if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            return true
        }
        if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            return true
        }
        return false;
    }
    
    public static func numbersFromString(_ string: String?) -> Int {
        if TextUtils.isEmpty(string) {
            Logger.e("Called numbersFromString method with an invalid string")
            return Constants.INVALID
        }
        var builder = Constants.EMPTY
        for char in string! {
            if char.isNumber {
                builder.append(char)
            }
        }
        var identifier = builder
        if identifier.count > 16 {
            // remove the prefix to avoid cast to long exceptions
            identifier = String(identifier.suffix(16))
        }
        let identifierInt = Int(identifier) ?? 0
        return abs(identifierInt)
    }
}
