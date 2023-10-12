//
//  HealthType.swift
//  App
//
//  Created by George Stavrou on 11/07/2023.
//

import UIKit

public enum HealthType: CaseIterable {
    
    case UNDEFINED
    case MOBILITY
    case SELF_CARE
    case USUAL_ACTIVITIES
    case PAIN
    case ANXIETY
    case SCORE
    
    
    var id: Int {
        switch self {
        case .UNDEFINED: return 0
        case .MOBILITY: return 1
        case .SELF_CARE: return 2
        case .USUAL_ACTIVITIES: return 3
        case .PAIN: return 4
        case .ANXIETY: return 5
        case .SCORE: return 6
        }
    }
    
    var title: String {
        switch self {
        case .UNDEFINED: return StringProvider.get("mobility")
        case .MOBILITY: return StringProvider.get("mobility")
        case .SELF_CARE: return StringProvider.get("health_self_care")
        case .USUAL_ACTIVITIES: return StringProvider.get("health_usual_activities")
        case .PAIN: return StringProvider.get("health_pain")
        case .ANXIETY: return StringProvider.get("health_anxiety")
        case .SCORE: return StringProvider.get("health_score")
            
        }
    }
    
    var responseOne: [String]? {
        switch self {
        case .UNDEFINED: return [Constants.HEALTH_RESPONSE_ONE_ID, StringProvider.get("health_mobility_response_one")]
        case .MOBILITY: return [Constants.HEALTH_RESPONSE_ONE_ID, StringProvider.get("health_mobility_response_one")]
        case .SELF_CARE: return [Constants.HEALTH_RESPONSE_ONE_ID, StringProvider.get("health_self_care_response_one")]
        case .USUAL_ACTIVITIES: return [Constants.HEALTH_RESPONSE_ONE_ID, StringProvider.get("health_usual_activities_response_one")]
        case .PAIN: return [Constants.HEALTH_RESPONSE_ONE_ID, StringProvider.get("health_pain_response_one")]
        case .ANXIETY: return [Constants.HEALTH_RESPONSE_ONE_ID, StringProvider.get("health_anxiety_response_one")]
        case .SCORE: return []
        }
    }
    
    var responseTwo: [String]? {
        switch self {
        case .UNDEFINED: return [Constants.HEALTH_RESPONSE_TWO_ID, StringProvider.get("health_mobility_response_two")]
        case .MOBILITY: return [Constants.HEALTH_RESPONSE_TWO_ID, StringProvider.get("health_mobility_response_two")]
        case .SELF_CARE: return [Constants.HEALTH_RESPONSE_TWO_ID, StringProvider.get("health_self_care_response_two")]
        case .USUAL_ACTIVITIES: return [Constants.HEALTH_RESPONSE_TWO_ID, StringProvider.get("health_usual_activities_response_two")]
        case .PAIN: return [Constants.HEALTH_RESPONSE_TWO_ID, StringProvider.get("health_pain_response_two")]
        case .ANXIETY: return [Constants.HEALTH_RESPONSE_TWO_ID, StringProvider.get("health_anxiety_response_two")]
        case .SCORE: return []
        }
    }
    
    var responseThree: [String]? {
        switch self {
        case .UNDEFINED: return [Constants.HEALTH_RESPONSE_THREE_ID, StringProvider.get("health_mobility_response_four")]
        case .MOBILITY: return [Constants.HEALTH_RESPONSE_THREE_ID, StringProvider.get("health_mobility_response_four")]
        case .SELF_CARE: return [Constants.HEALTH_RESPONSE_THREE_ID, StringProvider.get("health_self_care_response_four")]
        case .USUAL_ACTIVITIES: return [Constants.HEALTH_RESPONSE_THREE_ID, StringProvider.get("health_usual_activities_response_four")]
        case .PAIN: return [Constants.HEALTH_RESPONSE_THREE_ID, StringProvider.get("health_pain_response_four")]
        case .ANXIETY: return [Constants.HEALTH_RESPONSE_THREE_ID, StringProvider.get("health_anxiety_response_four")]
        case .SCORE: return []
        }
    }
    
    
    var responseFour: [String]? {
        switch self {
        case .UNDEFINED: return [Constants.HEALTH_RESPONSE_FOUR_ID, StringProvider.get("health_mobility_response_three")]
        case .MOBILITY: return [Constants.HEALTH_RESPONSE_FOUR_ID, StringProvider.get("health_mobility_response_three")]
        case .SELF_CARE: return [Constants.HEALTH_RESPONSE_FOUR_ID, StringProvider.get("health_self_care_response_three")]
        case .USUAL_ACTIVITIES: return [Constants.HEALTH_RESPONSE_FOUR_ID, StringProvider.get("health_usual_activities_response_three")]
        case .PAIN: return [Constants.HEALTH_RESPONSE_FOUR_ID, StringProvider.get("health_pain_response_three")]
        case .ANXIETY: return [Constants.HEALTH_RESPONSE_FOUR_ID, StringProvider.get("health_anxiety_response_three")]
        case .SCORE: return []
        }
    }
    
    
    var responseFive: [String]? {
        switch self {
        case .UNDEFINED: return [Constants.HEALTH_RESPONSE_FIVE_ID, StringProvider.get("health_mobility_response_five")]
        case .MOBILITY: return [Constants.HEALTH_RESPONSE_FIVE_ID, StringProvider.get("health_mobility_response_five")]
        case .SELF_CARE: return [Constants.HEALTH_RESPONSE_FIVE_ID, StringProvider.get("health_self_care_response_five")]
        case .USUAL_ACTIVITIES: return [Constants.HEALTH_RESPONSE_FIVE_ID, StringProvider.get("health_usual_activities_response_five")]
        case .PAIN: return [Constants.HEALTH_RESPONSE_FIVE_ID, StringProvider.get("health_pain_response_five")]
        case .ANXIETY: return [Constants.HEALTH_RESPONSE_FIVE_ID, StringProvider.get("health_anxiety_response_five")]
        case .SCORE: return []
        }
    }
    
    
    
    public static func getById(_ id: Int) -> HealthType {
        
        
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        return UNDEFINED
    }

    
    public static func getDescription(_ type: HealthType) -> String {
        
        if type == USUAL_ACTIVITIES {
            return String(format: StringProvider.get("health_description"), type.title) + "\n" + StringProvider.get("health_usual_activities_example")
        } else if type == SCORE {
            return StringProvider.get("health_score_description")
        }
        
        return String(format: StringProvider.get("health_description"), type.title)
    }
    
    
    public static func getResponse(_ responseId: String, _ type: HealthType) -> String {
        
        switch responseId {
        case Constants.HEALTH_RESPONSE_ONE_ID: return type.responseOne![1]
        case Constants.HEALTH_RESPONSE_TWO_ID: return type.responseTwo![1]
        case Constants.HEALTH_RESPONSE_THREE_ID: return type.responseThree![1]
        case Constants.HEALTH_RESPONSE_FOUR_ID: return type.responseFour![1]
        case Constants.HEALTH_RESPONSE_FIVE_ID: return type.responseFive![1]
        default:
            return Constants.EMPTY
        }
    }
    
    
    
    
    
    
    
    
    
}
