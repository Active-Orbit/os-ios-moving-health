//
//  UploadRequest.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//

import Foundation
import Tracker

public class UploadRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case customerId
        case customerName
        case customerGroup
        case segments
        case activities

        var rawValue: String {
            get {
                switch self {
                    case .customerId: return "customer_id"
                    case .customerName: return "customer_name"
                    case .customerGroup: return "customer_group"
                    case .segments: return "segments"
                    case .activities: return "activities"
                }
            }
        }
    }
    
    var customerId = Constants.EMPTY
    var customerName = Constants.EMPTY
    var customerGroup = Constants.EMPTY
    var segments = [UploadSegmentRequest]()
    var activities = [UploadActivityRequest]()
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(customerId) &&
            !TextUtils.isEmpty(customerName) &&
            !TextUtils.isEmpty(customerGroup) &&
            (segments.count > 0 || activities.count > 0)
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func toJson() -> String? {
        return Gson.toJsonString(self)
    }
}
