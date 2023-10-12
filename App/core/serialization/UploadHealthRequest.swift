//
//  UploadHealthRequest.swift
//  App
//
//  Created by Omar Brugna on 22/08/23.
//

import Foundation

public class UploadHealthRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case userId
        case healthResponse
        
        var rawValue: String {
            get {
                switch self {
                    case .userId: return "userId"
                    case .healthResponse: return "healthResponse"
                }
            }
        }
    }
    
    var userId: String?
    var healthResponse = UploadHealthResponse()
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(userId) && healthResponse.isValid()
    }
    
    public func toJson() -> String? {
        return Gson.toJsonString(self)
    }
    
    public class UploadHealthResponse: BaseRequest {
        
        fileprivate enum CodingKeys: String, CodingKey {
            case timestamp
            case healthID
            case mobility
            case selfCare
            case usualActivities
            case pain
            case anxiety
            case score
            
            var rawValue: String {
                get {
                    switch self {
                        case .timestamp: return "timeInMsecs"
                        case .healthID: return "id"
                        case .mobility: return "mobility"
                        case .selfCare: return "selfCare"
                        case .usualActivities: return "usualActivities"
                        case .pain: return "pain"
                        case .anxiety: return "anxiety"
                        case .score: return "score"
                    }
                }
            }
        }
        
        var timestamp = Constants.INVALID
        var healthID = Constants.INVALID
        var mobility: Int?
        var selfCare: Int?
        var usualActivities: Int?
        var pain: Int?
        var anxiety: Int?
        var score: Int?
        
        public func identifier() -> String {
            return Constants.EMPTY
        }
        
        public func isValid() -> Bool {
            return timestamp != Constants.INVALID &&
            mobility != nil &&
            selfCare != nil &&
            usualActivities != nil &&
            pain != nil &&
            anxiety != nil &&
            score != nil
        }
        
        public func toJson() -> String? {
            return Gson.toJsonString(self)
        }
    }
}
