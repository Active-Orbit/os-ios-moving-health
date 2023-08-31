//
//  Singleton.swift
//  App
//
//  Created by Omar Brugna on 31/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

public class Singleton {
    
    public static var currentDateTime = TimeUtils.startOfDay()
    public static var dayTotalToday: DayTotal?
    
    public static var startDate: Date {
        get {
            return currentDateTime.startOfDay
        }
    }
    
    public static var endDate: Date {
        get {
            return currentDateTime.endOfDay
        }
    }
    
    #if !os(watchOS)
    public static func onUpdate(_ controller: BaseController, _ dayTotal: DayTotal) {
        if dayTotal.isValid() {
            let dayTotalCalendar = dayTotal.dateTime!
            let currentCalendar = currentDateTime
            if TimeUtils.isSameDay(currentCalendar, dayTotalCalendar) {
                dayTotalToday = dayTotal
                ActivityManager.analyseTodayActivities(controller)
            } else {
                if !TimeUtils.isBeforeComputationDay(dayTotalCalendar) {
                    // analyse the activities of previous days if they were not analysed
                    ActivityManager.analyseDayActivities(controller, dayTotal, {
                        // analyse the next days
                        ActivityManager.startAnalyse(controller)
                    })
                } else {
                    ActivityManager.analyseTodayActivities(controller)
                }
            }
        } else {
            Logger.e("Day total calendar is null")
        }
    }
    #endif
}
