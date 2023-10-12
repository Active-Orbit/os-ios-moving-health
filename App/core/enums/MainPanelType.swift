//
//  MainPanelType.swift
//  App
//
//  Created by Omar Brugna on 29/06/23.
//

import UIKit

public enum MainPanelType {
    
    case UNDEFINED
    case REGISTER
    case TOUR
    case START_STUDY
    case START_STUDY_WITH_NAME
    case PRESCRIPTIONS_DOCTOR
    case PRESCRIPTIONS_PATIENT
    case SYMPTOMS_PATIENT
    case ACTIVITY_PATIENT
    
    var id: Int {
        switch self {
            case .UNDEFINED: return 0
            case .REGISTER: return 1
            case .TOUR: return 2
            case .START_STUDY: return 3
            case .START_STUDY_WITH_NAME: return 4
            case .PRESCRIPTIONS_DOCTOR: return 5
            case .PRESCRIPTIONS_PATIENT: return 6
            case .SYMPTOMS_PATIENT: return 7
            case .ACTIVITY_PATIENT: return 8
        }
    }
    
    var description: String {
        switch self {
            case .UNDEFINED: return StringProvider.get("patient_registration_intro")
            case .REGISTER: return StringProvider.get("patient_registration_intro")
            case .TOUR: return StringProvider.get("tour_description")
            case .START_STUDY: return StringProvider.get("patient_start_study")
            case .START_STUDY_WITH_NAME: return StringProvider.get("patient_start_study_with_name")
            case .PRESCRIPTIONS_DOCTOR: return StringProvider.get("add_patient_prescriptions")
            case .PRESCRIPTIONS_PATIENT: return StringProvider.get("see_prescriptions")
            case .SYMPTOMS_PATIENT: return StringProvider.get("report_symptom")
            case .ACTIVITY_PATIENT: return StringProvider.get("check_activity")
        }
    }
    
    var icon: UIImage? {
        switch self {
            case .UNDEFINED: return UIImage(named: "ic_logo_secondary")
            case .REGISTER: return UIImage(named: "ic_logo_secondary")
            case .TOUR: return UIImage(named: "ic_logo_secondary")
            case .START_STUDY: return UIImage(named: "ic_logo_secondary")
            case .START_STUDY_WITH_NAME: return UIImage(named: "ic_logo_secondary")
            case .PRESCRIPTIONS_DOCTOR: return UIImage(named: "ic_logo_secondary")
            case .PRESCRIPTIONS_PATIENT: return UIImage(named: "ic_logo_secondary")
            case .SYMPTOMS_PATIENT: return UIImage(named: "ic_logo_secondary")
            case .ACTIVITY_PATIENT: return UIImage(named: "ic_logo_secondary")
        }
    }
    
    var buttonText: String {
        switch self {
            case .UNDEFINED: return StringProvider.get("register_patient")
            case .REGISTER: return StringProvider.get("register_patient")
            case .TOUR: return StringProvider.get("take_tour")
            case .START_STUDY: return StringProvider.get("start_study")
            case .START_STUDY_WITH_NAME: return StringProvider.get("start_study")
            case .PRESCRIPTIONS_DOCTOR: return StringProvider.get("add_prescriptions")
            case .PRESCRIPTIONS_PATIENT: return StringProvider.get("my_prescriptions")
            case .SYMPTOMS_PATIENT: return StringProvider.get("symptoms")
            case .ACTIVITY_PATIENT: return StringProvider.get("activity")
        }
    }
    
    var image: UIImage? {
        switch self {
            case .UNDEFINED: return UIImage(named: "bg_tour_panel")
            case .REGISTER: return UIImage(named: "bg_register_panel")
            case .TOUR: return UIImage(named: "bg_register_panel")
            case .START_STUDY: return UIImage(named: "bg_register_panel")
            case .START_STUDY_WITH_NAME: return UIImage(named: "bg_register_panel")
            case .PRESCRIPTIONS_DOCTOR: return UIImage(named: "bg_register_panel")
            case .PRESCRIPTIONS_PATIENT: return UIImage(named: "bg_register_panel")
            case .SYMPTOMS_PATIENT: return UIImage(named: "bg_register_panel")
            case .ACTIVITY_PATIENT: return UIImage(named: "bg_register_panel")
        }
    }
}
