//
//  Controllers.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import SideMenu

public enum Controllers : ControllerProvider {
    
    case ABOUT
    case ACTIVITIES
    case CONSENT_FORM
    case CONSENT_PRIVACY
    case DOCTOR
    case FAQ
    case MAIN
    case PATIENT
    case PATIENT_DETAILS
    case SIDE_MENU
    case SEGMENTS
    case SPLASH
    case SUCCESS_MESSAGE
    case TOUR
    case WEBVIEW
    case WELCOME
    case HELP
    case CONTACT_US
    case SETTINGS
    case HEALTH_MOBILITY
    case HEALTH_SELFCARE
    case HEALTH_USUAL_ACTIVITIES
    case HEALTH_PAIN
    case HEALTH_ANXIETY
    case HEALTH_SCORE
    case HEALTH_RESPONSE
    case HEALTH
    case MAP
    case ONBOARDING_LOCATION
    
    var storyboard: String {
        switch self {
            case .ABOUT: return "Help"
            case .ACTIVITIES: return "Patient"
            case .CONSENT_FORM: return "Doctor"
            case .CONSENT_PRIVACY: return "Doctor"
            case .DOCTOR: return "Doctor"
            case .FAQ: return "Help"
            case .MAIN: return "Main"
            case .PATIENT: return "Patient"
            case .PATIENT_DETAILS: return "Doctor"
            case .SIDE_MENU: return "SideMenu"
            case .SEGMENTS: return "Segments"
            case .SPLASH: return "Main"
            case .SUCCESS_MESSAGE: return "Help"
            case .TOUR: return "Doctor"
            case .WEBVIEW: return "Main"
            case .WELCOME: return "Main"
            case .HELP: return "Help"
            case .CONTACT_US: return "Help"
            case .SETTINGS: return "Help"
            case .HEALTH_MOBILITY: return "Health"
            case .HEALTH_SELFCARE: return "Health"
            case .HEALTH_USUAL_ACTIVITIES: return "Health"
            case .HEALTH_PAIN: return "Health"
            case .HEALTH_ANXIETY: return "Health"
            case .HEALTH_SCORE: return "Health"
            case .HEALTH_RESPONSE: return "Health"
            case .HEALTH: return "Health"
            case .MAP: return "Patient"
            case .ONBOARDING_LOCATION: return "Doctor"
        }
    }
    
    var identifier: String {
        switch self {
            case .ABOUT: return "ABOUT"
            case .ACTIVITIES: return "ACTIVITIES"
            case .CONSENT_FORM: return "CONSENT_FORM"
            case .CONSENT_PRIVACY: return "CONSENT_PRIVACY"
            case .DOCTOR: return "DOCTOR"
            case .FAQ: return "FAQ"
            case .MAIN: return "MAIN"
            case .PATIENT: return "PATIENT"
            case .PATIENT_DETAILS: return "PATIENT_DETAILS"
            case .SIDE_MENU: return "SIDE_MENU"
            case .SEGMENTS: return "SEGMENTS"
            case .SPLASH: return "SPLASH"
            case .SUCCESS_MESSAGE: return "SUCCESS_MESSAGE"
            case .TOUR: return "TOUR"
            case .WEBVIEW: return "WEBVIEW"
            case .WELCOME: return "WELCOME"
            case .HELP: return "HELP"
            case .CONTACT_US: return "CONTACT_US"
            case .SETTINGS: return "SETTINGS"
            case .HEALTH_MOBILITY: return "HEALTH_MOBILITY"
            case .HEALTH_SELFCARE: return "HEALTH_SELFCARE"
            case .HEALTH_USUAL_ACTIVITIES: return "HEALTH_USUAL_ACTIVITIES"
            case .HEALTH_PAIN: return "HEALTH_PAIN"
            case .HEALTH_ANXIETY: return "HEALTH_ANXIETY"
            case .HEALTH_SCORE: return "HEALTH_SCORE"
            case .HEALTH_RESPONSE: return "HEALTH_RESPONSE"
            case .HEALTH: return "HEALTH"
            case .MAP: return "MAP"
            case .ONBOARDING_LOCATION: return "ONBOARDING_LOCATION"
        }
    }
    
    public func getController() -> BaseController {
        let storyboard = UIStoryboard(name: self.storyboard, bundle: mainBundle)
        return storyboard.instantiateViewController(withIdentifier: self.identifier) as! BaseController
    }
    
    public func getSideMenuController() -> SideMenuNavigationController {
        let storyboard = UIStoryboard(name: self.storyboard, bundle: mainBundle)
        return storyboard.instantiateViewController(withIdentifier: self.identifier) as! SideMenuNavigationController
    }
}
