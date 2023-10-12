//
//  LocationUtils.swift
//  BaseApp
//
//  Created by Omar Brugna on 12/06/2020.
//

import Foundation
import UIKit
import CoreLocation

/**
 * Utility class that provides some useful methods to manage locations
 */
public class LocationUtils {
    
    public static func toLocation(_ latitude: Double, _ longitude: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: latitude)!, longitude: CLLocationDegrees(exactly: longitude)!)
    }
    
    public static func getDistance(_ locationA: CLLocationCoordinate2D, _ locationB: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: locationA.latitude, longitude: locationA.longitude)
        let location2 = CLLocation(latitude: locationB.latitude, longitude: locationB.longitude)
        let distance = location1.distance(from: location2)
        Logger.d("Distance between locations is \(distance)")
        return distance
    }
}
