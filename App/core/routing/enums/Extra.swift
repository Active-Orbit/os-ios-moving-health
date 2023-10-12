//
//  Extra.swift
//  BaseApp
//
//  Created by Omar Brugna on 12/06/2020.
//

import Foundation

public enum Extra {
    
    case FROM_MENU
    case FROM_HELP
    case MODEL
    case MODELS
    case MODEL_ID
    case WEBVIEW_URL
    case WEBVIEW_TITLE
    case HEALTH_MOBILITY
    case HEALTH_SELF_CARE
    case HEALTH_ACTIVITY
    case HEALTH_ANXIETY
    case HEALTH_PAIN
    case POSITION
    case SUCCESS_MESSAGE
    case USER_NHS_NUMBER
    case USER_SEX
    case USER_AGE
    case USER_WEIGHT
    case USER_HEIGHT
    case USER_FIRST_NAME
    case USER_LAST_NAME
    case USER_DOB
    case USER_POSTCODE
    case USER_CONSENT_NAME
    case USER_CONSENT_DATE
    case IDENTIFIER
    
    public var key: String {
        switch self {
        case .FROM_MENU: return "from_menu"
        case .FROM_HELP: return "from_help"
        case .MODEL: return "model_extra"
        case .MODELS: return "models_extra"
        case .MODEL_ID: return "model_id_extra"
        case .WEBVIEW_URL: return "webview_url"
        case .WEBVIEW_TITLE: return "webview_title"
        case .HEALTH_MOBILITY: return "mobility_response"
        case .HEALTH_SELF_CARE: return "selfcare_response"
        case .HEALTH_ACTIVITY: return "activity_response"
        case .HEALTH_ANXIETY: return "anxiety_response"
        case .POSITION: return "position"
        case .HEALTH_PAIN: return "pain_response"
        case .SUCCESS_MESSAGE: return "success_message"
        case .USER_NHS_NUMBER: return "user_nhs_number"
        case .USER_SEX: return "user_sex"
        case .USER_AGE: return "user_age"
        case .USER_WEIGHT: return "user_weight"
        case .USER_HEIGHT: return "user_height"
        case .USER_FIRST_NAME: return "user_first_name"
        case .USER_LAST_NAME: return "user_last_name"
        case .USER_DOB: return "user_dob"
        case .USER_POSTCODE: return "user_postcode"
        case .USER_CONSENT_NAME: return "user_consent_name"
        case .USER_CONSENT_DATE: return "user_consent_date"
        case .IDENTIFIER: return "identifier_extra"
        }
    }
}
