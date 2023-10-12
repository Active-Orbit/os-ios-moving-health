//
//  DBHealth.swift
//  App
//
//  Created by George Stavrou on 13/07/2023.
//

import Foundation
import RealmSwift


public class DBHealth : DBModel {
    
    @objc dynamic public var healthID: String = Constants.EMPTY
    @objc dynamic public var healthMobility: Int = Constants.INVALID
    @objc dynamic public var healthSelfCare: Int = Constants.INVALID
    @objc dynamic public var healthActivities: Int = Constants.INVALID
    @objc dynamic public var healthAnxiety: Int = Constants.INVALID
    @objc dynamic public var healthPain: Int = Constants.INVALID
    @objc dynamic public var healthScore: Int = Constants.INVALID
    @objc dynamic public var healthTimestamp: Double = Double(Constants.INVALID)
    @objc dynamic public var uploaded = false
    
    public override class func primaryKey() -> String? {
        return "healthID"
    }
    
    override public func identifier() -> String {
        return healthID
    }
    
    override public func isValid() -> Bool {
        return healthMobility != Constants.INVALID
        && healthSelfCare != Constants.INVALID
        && healthActivities != Constants.INVALID
        && healthAnxiety != Constants.INVALID
        && healthPain != Constants.INVALID
        && healthScore != Constants.INVALID
        && healthTimestamp != Double(Constants.INVALID)
    }
    
    
    
    public func description() -> String {
        return "[\(healthID) - \(healthMobility) - \(healthSelfCare) - \(healthActivities) - \(healthAnxiety) - \(healthPain) - \(healthScore) - \(healthTimestamp)]"
    }
    
    
    
    
    
}
