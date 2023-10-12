//
//  SuccessMessageType.swift
//  App
//
//  Created by Omar Brugna on 17/07/23.
//

import UIKit

public enum SuccessMessageType: CaseIterable {
    
    case UNDEFINED
    case LOCATION_PERMISSION
    case BATTERY_PERMISSION
    case UNUSED_RESTRICTIONS
    case REGISTRATION
    case SYMPTOM_REPORTED
    case ON_BOARDING_COMPLETED
    case MEDICINE_REPORTED
    case DISMISS_PATIENT
    
    var id: Int {
        switch self {
            case .UNDEFINED: return 0
            case .LOCATION_PERMISSION: return 1
            case .BATTERY_PERMISSION: return 2
            case .UNUSED_RESTRICTIONS: return 3
            case .REGISTRATION: return 4
            case .SYMPTOM_REPORTED: return 5
            case .ON_BOARDING_COMPLETED: return 6
            case .MEDICINE_REPORTED: return 7
            case .DISMISS_PATIENT: return 8
        }
    }
    
    var message: String {
        switch self {
            case .UNDEFINED: return StringProvider.get("success")
            case .LOCATION_PERMISSION: return StringProvider.get("success_location_permissions")
            case .BATTERY_PERMISSION: return StringProvider.get("success_battery_settings")
            case .UNUSED_RESTRICTIONS: return StringProvider.get("success_disable_restrictions")
            case .REGISTRATION: return StringProvider.get("success_registration")
            case .SYMPTOM_REPORTED: return StringProvider.get("success_symptom_report")
            case .ON_BOARDING_COMPLETED: return StringProvider.get("success_on_boarding")
            case .MEDICINE_REPORTED: return StringProvider.get("success_medicine_reported")
            case .DISMISS_PATIENT: return StringProvider.get("success_dismiss_patient")
        }
    }
    
    public static func getById(_ id: Int) -> SuccessMessageType {
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        return UNDEFINED
    }
}
