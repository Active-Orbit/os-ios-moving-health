//
//  UploadSegmentRequest.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//

import Foundation
import Tracker

public class UploadSegmentRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case segmentId
        case type
        case duration
        case brisk
        case createdAt
        case startDate
        case endDate
        case floorsClimbed
        case distanceTravelled
        case numberOfBriskChunks
        case steps
        case userChanged
        
        var rawValue: String {
            get {
                switch self {
                    case .segmentId: return "segment_id"
                    case .type: return "segment_type"
                    case .duration: return "duration"
                    case .brisk: return "brisk"
                    case .createdAt: return "created_at"
                    case .startDate: return "start_date"
                    case .endDate: return "end_date"
                    case .floorsClimbed: return "floors_climbed"
                    case .distanceTravelled: return "distance"
                    case .numberOfBriskChunks: return "brisk_chunks"
                    case .steps: return "steps"
                    case .userChanged: return "user_changed"
                }
            }
        }
    }
    
    var segmentId: String = Constants.EMPTY
    var type: String = Constants.EMPTY
    var duration: String = Constants.EMPTY
    var brisk: String = Constants.EMPTY
    var createdAt: String = Constants.EMPTY
    var startDate: String = Constants.EMPTY
    var endDate: String = Constants.EMPTY
    var floorsClimbed: String = Constants.EMPTY
    var distanceTravelled: String = Constants.EMPTY
    var numberOfBriskChunks: String = Constants.EMPTY
    var steps: String = Constants.EMPTY
    var userChanged: String = Constants.EMPTY
    
    init(_ segment: TrackerDBSegment) {
        segmentId = segment.segmentId
        type = String(segment.type)
        duration = String(segment.activityDuration)
        brisk = String(segment.brisk)
        if segment.createdAt != nil {
            createdAt = TimeUtils.format(segment.createdAt!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
        }
        if segment.startDate != nil {
            startDate = TimeUtils.format(segment.startDate!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
        }
        if segment.endDate != nil {
            endDate = TimeUtils.format(segment.endDate!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
        }
        floorsClimbed = String(segment.floorsClimbed)
        distanceTravelled = String(segment.distanceTravelled)
        numberOfBriskChunks = String(segment.numberOfBriskChunks)
        steps = String(segment.steps)
        userChanged = String(segment.userChanged)
    }
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(segmentId)
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func toJson() -> String? {
        return Gson.toJsonString(self)
    }
}
