//
//  ActivityManager.swift
//  App
//
//  Created by Omar Brugna on 31/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import Tracker

/**
 * Utility class to store user activities according to the tracker activity data
 */
public class ActivityManager {
    
    public static var isLoading = false
    
    public static func startAnalyse(_ controller: BaseController) {
        let lastAnalysed = TableAnalyse.getAll().first
        if lastAnalysed == nil {
            Logger.d("Last analysed day is null, analyse from initial date")
            
            isLoading = true
            BaseBroadcast.notifyActivitiesLoading(controller, StringProvider.get("compute_activities"))
            
            let firstComputationDate = Preferences.lifecycle.firstComputation
            if firstComputationDate != nil {
                // analyse from initial date
                let from = Preferences.lifecycle.firstComputation!
                let to = TimeUtils.endOfDay(Preferences.lifecycle.firstComputation!)
                TrackerManager.instance.refresh(from, to, {
                    let identifier = TimeUtils.format(from, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    let subIdentifier = TimeUtils.format(to, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    BaseBroadcast.notifyTrackerDataUpdated(controller, identifier: identifier, subIdentifier: subIdentifier)
                })
            } else {
                Logger.d("Waiting for first computation millis preference to be validated")
            }
            
        } else {
            
            let lastAnalysedCalendar = lastAnalysed!.getCalendar()
            var yesterdayCalendar = TimeUtils.startOfDay(Singleton.currentDateTime)
            yesterdayCalendar = yesterdayCalendar.add(component: .day, value: -1)!
            
            if !lastAnalysedCalendar.before(yesterdayCalendar) {
                Logger.d("Last analysed day is yesterday, analyse today")
                
                isLoading = true
                BaseBroadcast.notifyActivitiesLoading(controller, StringProvider.get("compute_activities"))
                
                // analyse today
                let from = TimeUtils.startOfDay(Singleton.currentDateTime)
                let to = TimeUtils.endOfDay(Singleton.currentDateTime)
                TrackerManager.instance.refresh(from, to, {
                    let identifier = TimeUtils.format(from, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    let subIdentifier = TimeUtils.format(to, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    BaseBroadcast.notifyTrackerDataUpdated(controller, identifier: identifier, subIdentifier: subIdentifier)
                })
                
            } else {
                Logger.d("Last analysed day is \(TimeUtils.format(lastAnalysedCalendar, Constants.DATE_FORMAT_UTC, convertToDefault: true)) analyse the next day")
                
                // analyse next day
                let from = lastAnalysedCalendar.add(component: .day, value: 1)!
                
                isLoading = true
                BaseBroadcast.notifyActivitiesLoading(controller, StringProvider.get("compute_activities"))
                
                let to = TimeUtils.endOfDay(from)
                TrackerManager.instance.refresh(from, to, {
                    let identifier = TimeUtils.format(from, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    let subIdentifier = TimeUtils.format(to, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    BaseBroadcast.notifyTrackerDataUpdated(controller, identifier: identifier, subIdentifier: subIdentifier)
                })
            }
        }
    }
    
    public static func analyseTodayActivities(_ controller: BaseController) {
        // the current day won't be set as analysed because we could have new progress during the day
        BaseBroadcast.notifyActivitiesUpdated(controller)
    }
    
    public static func analyseDayActivities(_ controller: BaseController, _ dayTotal: DayTotal, _ listener: ClosureVoid) {
        let analyseModel = DBAnalyse()
        analyseModel.timeInMillis = dayTotal.dateTime!.timeInMillis
        analyseModel.generateId()
        let analysed = TableAnalyse.getById(analyseModel.analyseId)?.isValid() == true
        if !analysed {
            // mark day as analysed
            TableAnalyse.upsert(analyseModel)
            listener()
        } else {
            let dayCalendar = dayTotal.dateTime!
            Logger.d("Activities already analysed for \(TimeUtils.format(dayCalendar, Constants.DATE_FORMAT_UTC, convertToDefault: true)) ")
            listener()
        }
    }
}
