//
//  DayTotal.swift
//  App
//
//  Created by Omar Brugna on 31/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import Tracker

public class DayTotal: BaseProtocol, Equatable {
    
    public static func == (lhs: DayTotal, rhs: DayTotal) -> Bool {
        return lhs.dateTime == rhs.dateTime &&
            lhs.timeBriskWalking == rhs.timeBriskWalking &&
            lhs.timeWalking == rhs.timeWalking &&
            lhs.timeRunning == rhs.timeRunning &&
            lhs.timeCycling == rhs.timeCycling &&
            lhs.timeInVehicle == rhs.timeInVehicle &&
            lhs.timeOther == rhs.timeOther &&
            lhs.trajectories == rhs.trajectories &&
            lhs.numberOfSteps == rhs.numberOfSteps &&
            lhs.totalDistanceWalked == rhs.totalDistanceWalked &&
            lhs.totalDistanceRunned == rhs.totalDistanceRunned &&
            lhs.totalDistanceCycled == rhs.totalDistanceCycled &&
            lhs.totalDistanceDriven == rhs.totalDistanceDriven
    }
    
    var dateTime: Date?
    var timeBriskWalking: Double = 0
    var timeWalking: Double = 0
    var timeRunning: Double = 0
    var timeCycling: Double = 0
    var timeInVehicle: Double = 0
    var timeOther: Double = 0
    var trajectories = [TrackerDBSegment]()
    var numberOfSteps: Int = 0
    var totalDistanceWalked: Double = 0.0
    var totalDistanceRunned: Double = 0.0
    var totalDistanceCycled: Double = 0.0
    var totalDistanceDriven: Double = 0.0
    
    init(_ date: Date, _ segments: [TrackerDBSegment]) {
        dateTime = date
        
        for segment in segments {
            if segment.type == TrackerActivityType.CYCLING.id {
                // the total duration of the cycling activity is considered as brisk
                segment.numberOfBriskChunks = segment.activityDuration / 60
            }
        }
        
        timeBriskWalking = Double(segments.sumOf({ it in
            if it.type == TrackerActivityType.WALKING.id || it.type == TrackerActivityType.RUNNING.id || it.type == TrackerActivityType.CYCLING.id {
                if it.numberOfBriskChunks != TrackerConstants.INVALID { return it.numberOfBriskChunks * 60 }
            }
            return 0
        }))
        timeWalking = Double(segments.sumOf({ it in
            if it.type == TrackerActivityType.WALKING.id {
                return it.activityDuration
            }
            return 0
        }))
        timeRunning = Double(segments.sumOf({ it in
            if it.type == TrackerActivityType.RUNNING.id {
                return it.activityDuration
            }
            return 0
        }))
        timeCycling = Double(segments.sumOf({ it in
            if it.type == TrackerActivityType.CYCLING.id {
                return it.activityDuration
            }
            return 0
        }))
        timeInVehicle = Double(segments.sumOf({ it in
            if it.type == TrackerActivityType.AUTOMOTIVE.id {
                return it.activityDuration
            }
            return 0
        }))
        timeOther = Double(segments.sumOf({ it in
            if it.type == TrackerActivityType.OTHER.id ||
                it.type == TrackerActivityType.UNDEFINED.id ||
                it.type == TrackerActivityType.STATIONARY.id {
                return it.activityDuration
            }
            return 0
        }))
        numberOfSteps = segments.sumOf({ it in
            return it.steps
        })
        totalDistanceWalked = Double(segments.sumOf({ it in
            return Int(it.getDistance([.WALKING], true))
        }))
        totalDistanceRunned = Double(segments.sumOf({ it in
            return Int(it.getDistance([.RUNNING], true))
        }))
        totalDistanceCycled = Double(segments.sumOf({ it in
            return Int(it.getDistance([.CYCLING], true))
        }))
        totalDistanceDriven = Double(segments.sumOf({ it in
            return Int(it.getDistance([.AUTOMOTIVE], false))
        }))
        
        trajectories = segments
    }
    
    open func isValid() -> Bool {
        return dateTime != nil
    }
    
    public func identifier() -> String {
        return TimeUtils.format(dateTime!, Constants.DATE_FORMAT_ID, convertToDefault: true)
    }
}
