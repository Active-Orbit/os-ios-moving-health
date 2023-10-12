//
//  DateExtension.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

extension Date {
    
    public init(timeInMillis: Double) {
        self.init(timeIntervalSince1970: timeInMillis / 1000)
    }
    
    public var zeroSeconds: Date {
        get {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
            components.second = 0
            components.nanosecond = 0
            return calendar.date(from: components) ?? self
        }
    }
    
    public var startOfDay: Date {
        get {
            var calendar = Calendar.current
            calendar.timeZone = TimeUtils.utcTimezone
            let components = calendar.dateComponents([.year, .month, .day], from: self)
            return calendar.date(from: components) ?? self
        }
    }

    public var endOfDay: Date {
        get {
            let calendar = Calendar.current
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return calendar.date(byAdding: components, to: startOfDay)!
        }
    }
    
    public var timeInMillis: Double {
        get {
            return Double(timeIntervalSince1970 * 1000)
        }
    }
    
    public static var utc: Date {
        get {
            return Date()
        }
    }
    
    public static var current: Date {
        get {
            let utcDate = utc
            let timeZoneOffset = Double(TimeUtils.defaultTimezone.secondsFromGMT(for: utcDate))
            let currentDate = utcDate.add(component: .second, value: Int(timeZoneOffset))
            return currentDate ?? utcDate
        }
    }
    
    public func toUTC() -> Date {
        let timeZoneOffset = Double(TimeUtils.defaultTimezone.secondsFromGMT(for: self))
        let currentDate = add(component: .second, value: Int(-timeZoneOffset))
        return currentDate ?? self
    }
    
    public func toCurrent() -> Date {
        let timeZoneOffset = Double(TimeUtils.defaultTimezone.secondsFromGMT(for: self))
        let currentDate = add(component: .second, value: Int(timeZoneOffset))
        return currentDate ?? self
    }
    
    public func before(_ date: Date) -> Bool {
        return compare(date) == .orderedAscending
    }
    
    public func after(_ date: Date) -> Bool {
        return compare(date) == .orderedDescending
    }
    
    public func add(component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
    public func get(component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
}
