//
//  DBAnalyse.swift
//  App
//
//  Created by Omar Brugna on 31/07/23.
//

import Foundation
import RealmSwift

public class DBAnalyse : DBModel {
    
    @objc dynamic public var analyseId: String = Constants.EMPTY
    @objc dynamic public var timeInMillis: Double = Double(Constants.INVALID)
    @objc dynamic public var createdAt: Double = TimeUtils.getCurrent().timeInMillis
    
    required override init() {
        
    }
    
    public override class func primaryKey() -> String? {
        return "analyseId"
    }
    
    override public func identifier() -> String {
        return analyseId
    }
    
    override public func isValid() -> Bool {
        return !TextUtils.isEmpty(analyseId) &&
            timeInMillis != Double(Constants.INVALID)
    }
    
    public func generateId() {
        let calendar = TimeUtils.getCurrent(timeInMillis)
        analyseId = TimeUtils.format(calendar, Constants.DATE_FORMAT_ID, convertToDefault: true)
    }
    
    public func description() -> String {
        return "[\(analyseId) - \(timeInMillis)]"
    }
    
    public func getCalendar() -> Date {
        return TimeUtils.getCurrent(timeInMillis)
    }
}
