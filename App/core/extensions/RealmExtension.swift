//
//  RealmExtension.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit
import Realm
import RealmSwift

public protocol RealmListDetachable {
    
    func detached() -> Self
}

@objc extension Object {
    
    public func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let detachable = value as? Object {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else if let list = value as? RealmListDetachable {
                detached.setValue(list.detached(), forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

extension List: RealmListDetachable where Element: Object {
    
    public func detached() -> List<Element> {
        let detached = self.detached
        let result = List<Element>()
        result.append(objectsIn: detached)
        return result
    }
}

extension Array: RealmListDetachable where Element: Object {
    
    public func detached() -> Array<Element> {
        let detached = self.detached
        var result = Array<Element>()
        result.append(contentsOf: detached)
        return result
    }
}

extension Sequence where Iterator.Element: Object {
    
    public var detached: [Element] {
        return map({ $0.detached() })
    }
}
