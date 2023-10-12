//
//  ActivityUtils.swift
//  App
//
//  Created by Omar Brugna on 01/08/23.
//

import UIKit
import Tracker

public class ActivityUtils {
    
    public static func getIcon(_ activityType: Int) -> UIImage? {
        switch activityType {
            case TrackerActivityType.STATIONARY.id:
                return ImageProvider.get("ic_walking")
            case TrackerActivityType.WALKING.id:
                return ImageProvider.get("ic_walking")
            case TrackerActivityType.RUNNING.id:
                return ImageProvider.get("ic_walking")
            case TrackerActivityType.CYCLING.id:
                return ImageProvider.get("ic_cycling")
            case TrackerActivityType.AUTOMOTIVE.id:
                return ImageProvider.get("ic_driving")
            default:
                return ImageProvider.get("ic_walking")
        }
    }

    public static func getName(_ activityType: Int) -> String {
        switch activityType {
            case TrackerActivityType.STATIONARY.id:
                return StringProvider.get("still")
            case TrackerActivityType.WALKING.id:
                return StringProvider.get("walking")
            case TrackerActivityType.RUNNING.id:
                return StringProvider.get("running")
            case TrackerActivityType.CYCLING.id:
                return StringProvider.get("cycling")
            case TrackerActivityType.AUTOMOTIVE.id:
                return StringProvider.get("vehicle")
            default:
                return StringProvider.get("unknown")
        }
    }
}
