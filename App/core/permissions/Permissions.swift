//
//  Permissions.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

/**
 * Utility class to manage runtime permissions
 */
public class Permissions: NSObject  {
    
    public var locationManager: CLLocationManager?
    public var motionManager: CMMotionActivityManager?
    public var pedometerManager: CMPedometer?
    
    fileprivate var mGroup: Group!
    
    public static let REQUEST_ACCESS_LOCATION_WHEN_IN_USE = 0
    public static let REQUEST_ACCESS_LOCATION_ALWAYS = 1
    public static let REQUEST_ACCESS_MOTION = 2
    public static let REQUEST_ACCESS_PEDOMETER = 3
    
    override init() {
        Exception("Do not use this constructor for permissions")
    }
    
    init(_ group: Group) {
        mGroup = group
    }
    
    public static func locationAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    public static func motionAuthorizationStatus() -> CMAuthorizationStatus {
        return CMMotionActivityManager.authorizationStatus()
    }
    
    public static func pedometerAuthorizationStatus() -> CMAuthorizationStatus {
        return CMPedometer.authorizationStatus()
    }
    
    public func check() -> Bool {
        switch mGroup.requestCode {
            case Permissions.REQUEST_ACCESS_LOCATION_WHEN_IN_USE:
                let status = Permissions.locationAuthorizationStatus()
                return status == .authorizedWhenInUse || status == .authorizedAlways
            case Permissions.REQUEST_ACCESS_LOCATION_ALWAYS:
                let status = Permissions.locationAuthorizationStatus()
                return status == .authorizedAlways
            case Permissions.REQUEST_ACCESS_MOTION:
                let status = Permissions.motionAuthorizationStatus()
                return status == .authorized
            case Permissions.REQUEST_ACCESS_PEDOMETER:
                let status = Permissions.pedometerAuthorizationStatus()
                return status == .authorized
            default:
                Logger.e("Undefined permission request code on check \(mGroup.requestCode)")
        }
        return false
    }
    
    public func request(listener: @escaping ClosureBool) {
        switch mGroup.requestCode {
            case Permissions.REQUEST_ACCESS_LOCATION_WHEN_IN_USE:
                let status = Permissions.locationAuthorizationStatus()
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    listener(true)
                } else if status == .notDetermined {
                    locationManager?.requestWhenInUseAuthorization()
                } else {
                    listener(false)
            }
            case Permissions.REQUEST_ACCESS_LOCATION_ALWAYS:
                let status = Permissions.locationAuthorizationStatus()
                if status == .authorizedAlways {
                    listener(true)
                } else if status == .notDetermined || status == .authorizedWhenInUse {
                    locationManager?.requestAlwaysAuthorization()
                } else {
                    listener(false)
            }
            case Permissions.REQUEST_ACCESS_MOTION:
                let status = Permissions.motionAuthorizationStatus()
                if status == .authorized {
                    listener(true)
                } else if status == .notDetermined {
                    motionManager?.queryActivityStarting(from: TimeUtils.getCurrent(), to: TimeUtils.getCurrent(), to: .main, withHandler: { _, error in
                        if error != nil && error!._code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                            listener(false)
                        } else {
                            listener(true)
                        }
                    })
                } else {
                    listener(false)
            }
            case Permissions.REQUEST_ACCESS_PEDOMETER:
                let status = Permissions.pedometerAuthorizationStatus()
                if status == .authorized {
                    listener(true)
                } else if status == .notDetermined {
                    pedometerManager?.queryPedometerData(from: TimeUtils.getCurrent(), to: TimeUtils.getCurrent(), withHandler: { _, error in
                        if error != nil && error!._code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                            listener(false)
                        } else {
                            listener(true)
                        }
                    })
                } else {
                    listener(false)
            }
            default:
                Logger.e("Undefined permission request code on request \(mGroup.requestCode)")
        }
    }
    
    public enum Group {
        case ACCESS_LOCATION_WHEN_IN_USE
        case ACCESS_LOCATION_ALWAYS
        case ACCESS_MOTION
        case ACCESS_PEDOMETER
        
        var requestCode: Int {
            switch self {
                case .ACCESS_LOCATION_WHEN_IN_USE: return REQUEST_ACCESS_LOCATION_WHEN_IN_USE
                case .ACCESS_LOCATION_ALWAYS: return REQUEST_ACCESS_LOCATION_ALWAYS
                case .ACCESS_MOTION: return REQUEST_ACCESS_MOTION
                case .ACCESS_PEDOMETER: return REQUEST_ACCESS_PEDOMETER
            }
        }
    }
}
