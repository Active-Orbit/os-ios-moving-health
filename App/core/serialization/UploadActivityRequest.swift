//
//  UploadActivityRequest.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import Tracker

public class UploadActivityRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case activityId
        case activityType
        case confidence
        case createdAt
        case startDate
        case endDate
        case floorsClimbed
        case pedometerChecked
        case steps
        case analysed
        
        var rawValue: String {
            get {
                switch self {
                    case .activityId: return "activity_id"
                    case .activityType: return "activity_type"
                    case .confidence: return "confidence"
                    case .createdAt: return "created_at"
                    case .startDate: return "start_date"
                    case .endDate: return "end_date"
                    case .floorsClimbed: return "floors_climbed"
                    case .pedometerChecked: return "pedometer_checked"
                    case .steps: return "steps"
                    case .analysed: return "analysed"
                }
            }
        }
    }
    
    var activityId: String = Constants.EMPTY
    var activityType: String = Constants.EMPTY
    var confidence: String = Constants.EMPTY
    var createdAt: String = Constants.EMPTY
    var startDate: String = Constants.EMPTY
    var endDate: String = Constants.EMPTY
    var floorsClimbed: String = Constants.EMPTY
    var pedometerChecked: String = Constants.EMPTY
    var steps: String = Constants.EMPTY
    var analysed: String = Constants.EMPTY
    
    init(_ activity: TrackerDBActivity) {
        activityId = activity.activityId
        activityType = String(activity.activityType)
        confidence = String(activity.confidence)
        if activity.createdAt != nil {
            createdAt = TimeUtils.format(activity.createdAt!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
        }
        if activity.startDate != nil {
            startDate = TimeUtils.format(activity.startDate!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
        }
        if activity.endDate != nil {
            endDate = TimeUtils.format(activity.endDate!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
        }
        floorsClimbed = String(activity.floorsClimbed)
        pedometerChecked = String(activity.pedometerChecked)
        steps = String(activity.steps)
        analysed = String(activity.analysed)
    }
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(activityId)
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func toJson() -> String? {
        return Gson.toJsonString(self)
    }
}
