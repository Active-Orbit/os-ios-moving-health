//
//  TimeUtils.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
 * Utility class that provides some useful methods to manage dates and timezones
 */
public class TimeUtils {
    
    public static let ONE_SECOND_MILLIS = 1000
    public static let ONE_MINUTE_MILLIS = 60 * ONE_SECOND_MILLIS
    public static let ONE_HOUR_MILLIS = 60 * ONE_MINUTE_MILLIS
    public static let ONE_DAY_MILLIS = 24 * ONE_HOUR_MILLIS
    
    public static let utcTimezone = TimeZone(abbreviation: "UTC")!
    public static let defaultTimezone = TimeZone.current
    
    public static func getUTC() -> Date {
        return Date.utc
    }
    
    public static func getCurrent(_ timeInMillis: Double? = nil) -> Date {
        if timeInMillis != nil {
            return Date(timeInMillis: timeInMillis!)
        }
        return Date.current
    }
    
    public static func toUTC(_ date: Date) -> Date {
        return date.toUTC()
    }
    
    public static func toDefault(_ date: Date) -> Date {
        return date.toCurrent()
    }
    
    public static func getZeroSeconds(_ fromDate: Date? = nil) -> Date {
        let date = fromDate ?? getCurrent()
        return date.zeroSeconds
    }
    
    /**
     Transform a UTC string date in a readable date
     For example, "2015-10-07 23:12:26" can become "today 23:12"
     
     - parameter stringDate the input string containings date
     - returns: the readable string date
     */
    public static func getReadableDate(_ date: Date, _ skipFuture: Bool) -> String {
        var formattedDate = date
        
        // get current local hour
        var now = getUTC()
        
        // can't handle future dates, compare in local
        if skipFuture && date.after(now) {
            now = now.addingTimeInterval(TimeInterval(-60))
            formattedDate = now
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        formatter.locale = .current
        
        return formatter.string(from: formattedDate)
    }
    
    public static func format(_ date: Date, _ toFormat: String, convertToDefault: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = toFormat
        formatter.timeZone = convertToDefault ? defaultTimezone : utcTimezone
        return formatter.string(from: date)
    }
    
    public static func parse(_ date: String?, _ fromFormat: String, convertToDefault: Bool) -> Date? {
        if TextUtils.isEmpty(date) {
            Logger.e("Trying to parse an empty date string")
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        formatter.timeZone = convertToDefault ? defaultTimezone : utcTimezone
        let dateParsed = formatter.date(from: date!)
        if dateParsed != nil {
            return dateParsed
        } else {
            Logger.e("Parsed date is null \(date!)")
        }
        return nil
    }
    
    public static func convertDate(_ date: String, _ fromFormat: String, _ toFormat: String, _ convertToDefault: Bool) -> String {
        let calendar = parse(date, fromFormat, convertToDefault: convertToDefault)
        if calendar != nil {
            return format(calendar!, toFormat, convertToDefault: convertToDefault)
        }
        return Constants.EMPTY
       
    }
    
    public static func copy(_ from: Date) -> Date {
        return (from as NSDate).copy() as! Date
    }
    
    public static func copyOrNow(_ from: Date? = nil) -> Date {
        if from == nil { return getCurrent() }
        return copy(from!)
    }
    
    public static func startOfDay(_ from: Date? = nil) -> Date {
        let date = copyOrNow(from)
        return date.startOfDay
    }
    
    public static func endOfDay(_ from: Date? = nil) -> Date {
        let date = copyOrNow(from)
        return date.endOfDay
    }
    
    fileprivate static func getCurrentDay() -> Int {
        return getCurrent().get(component: .day)
    }
    
    fileprivate static func getCurrentMonth() -> Int {
        return getCurrent().get(component: .month)
    }
    
    fileprivate static func getCurrentYear() -> Int {
        return getCurrent().get(component: .year)
    }
    
    public static func getDayDayOfMonth(_ date: Date?) -> Int {
        var dayOfMonth = 0
        if date != nil {
            let calendar = Calendar.current
            dayOfMonth = calendar.ordinality(of: .day, in: .month, for: date!) ?? 0
        }
        return dayOfMonth
    }
    
    public static func isBeforeComputationDay(_ date: Date) -> Bool {
        let computationDate = Preferences.lifecycle.firstComputation
        if computationDate != nil {
            let computationDateStartDay = computationDate!.startOfDay
            return date.before(computationDateStartDay)
        }
        Logger.e("Computation date is invalid")
        return false
    }
    
    public static func isToday(_ date: Date?) -> Bool {
        return isThisMonth(date) && date?.get(component: .day) == getCurrentDay()
    }
    
    public static func isThisMonth(_ date: Date?) -> Bool {
        return isThisYear(date) && date?.get(component: .month) == getCurrentMonth()
    }
    
    public static func isThisYear(_ date: Date?) -> Bool {
        return date?.get(component: .year) == getCurrentYear()
    }
    
    public static func isSameDay(_ dateStart: Date?, _ dateEnd: Date?) -> Bool {
        return dateStart?.get(component: .day) == dateEnd?.get(component: .day) &&
        dateStart?.get(component: .month) == dateEnd?.get(component: .month) &&
        dateStart?.get(component: .year) == dateEnd?.get(component: .year)
    }
    
    public static func formatHHMMSS(_ seconds: Int) -> String{
        //Calculate the seconds to display:
        let secondsCount = seconds % 60
        var secondsString = String(secondsCount)
        //Calculate the minutes:
        let minutesCount = seconds / 60 % 60
        var minutesString = String(minutesCount)
        //Calculate the hours:
        let hoursCount = seconds / 60 / 60
        var hoursString = String(hoursCount)
        secondsString = secondsString.padLeft(2, "0")
        minutesString = minutesString.padLeft(2, "0")
        hoursString = hoursString.padLeft(2, "0")
        //Build the String
        return "\(hoursString):\(minutesString):\(secondsString)"
        
    }
    
    public static func calculateSuffix(_ day: Int) -> String {
        let calculateDay = day % 10
        switch calculateDay {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
        }
    }
}
