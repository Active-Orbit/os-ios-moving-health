//
//  UserPreferences.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

public class UserPreferences : BasePreferences {
    
    internal func register(_ idUser: String) {
        self.idUser = idUser
    }

    internal func isUserRegistered() -> Bool {
        return !TextUtils.isEmpty(idUser)
    }
    
    public var idUser: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_id_user_key)
            
            if !TextUtils.isEmpty(newValue) {
                Crashlytics.crashlytics().setCustomValue(newValue!, forKey: "id_user")
            }
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_id_user_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var userNhsNumber: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_id_patient_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_id_patient_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var studyStarted: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_study_started_key)
        }
        get {
            return defaultsStandard.bool(forKey: PreferencesKeys.preference_user_study_started_key)
        }
    }
    
    public var dateStudyStarted: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_date_study_started_key)
        }
        get {
            return defaultsStandard.value(forKey: PreferencesKeys.preference_user_id_patient_key) as? Date
        }
    }
    
    public var watchSynchronized: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_watch_synchronized_key)
        }
        get {
            return defaultsStandard.bool(forKey: PreferencesKeys.preference_user_watch_synchronized_key)
        }
    }
    
    public var userSex: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_sex_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_sex_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var userFirstName: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_first_name_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_first_name_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var userLastName: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_last_name_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_last_name_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var userDateOfBirth: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_date_of_birth_key)
        }
        get {
            return defaultsStandard.value(forKey: PreferencesKeys.preference_user_date_of_birth_key) as? Date
        }
    }
    
    public var userPostcode: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_postcode_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_postcode_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var userEmail: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_email_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_email_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var userPhone: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_phone_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_phone_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var userConsentDate: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_consent_date_key)
        }
        get {
            return defaultsStandard.value(forKey: PreferencesKeys.preference_user_consent_date_key) as? Date
        }
    }
    
    public var userConsentName: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_consent_name_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_consent_name_key) ?? Constants.EMPTY) as? String
        }
    }
    
    public var consentFormText: String {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_consent_form_text_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_consent_form_text_key) ?? Constants.EMPTY) as! String
        }
    }
    
    public var consentVersion: Int {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_consent_form_version_key)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_consent_form_version_key) ?? Constants.INVALID) as! Int
        }
    }
    
    public var pushToken: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_user_push_token)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_user_push_token) ?? Constants.EMPTY) as? String
        }
    }
    
    public func userFullName() -> String {
        return "\(userFirstName ?? Constants.EMPTY) \(userLastName ?? Constants.EMPTY)"
    }
    
    public func logout() {
        idUser = nil
        userNhsNumber = nil
        studyStarted = false
        dateStudyStarted = nil
        watchSynchronized = false
        userSex = nil
        userFirstName = nil
        userLastName = nil
        userDateOfBirth = nil
        userPostcode = nil
        userConsentDate = nil
        userConsentName = nil
        userEmail = nil
        userPhone = nil
        // consentFormText = Constants.EMPTY
        // consentVersion = Constants.EMPTY
        // pushToken = nil
    }
}
