//
//  DBConsentQuestion.swift
//  App
//
//  Created by Omar Brugna on 17/07/2023.
//

import Foundation
import RealmSwift

public class DBConsentQuestion : DBModel {
    
    @objc dynamic public var questionID = Constants.EMPTY
    @objc dynamic public var questionText: String?
    
    public var checked = false
    
    public override class func primaryKey() -> String? {
        return "questionID"
    }
    
    public override class func ignoredProperties() -> [String] {
        return ["checked"]
    }
    
    override public func identifier() -> String {
        return questionID
    }
    
    override public func isValid() -> Bool {
        return !TextUtils.isEmpty(questionID) && questionText != nil
    }
    
    
    
    public func description() -> String {
        return "[\(questionID) - \(questionText ?? Constants.EMPTY)]"
    }
}
