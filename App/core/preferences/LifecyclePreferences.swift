//
//  LifecyclePreferences.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class LifecyclePreferences : BasePreferences {
    
    public var firstInstall: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_lifecycle_first_install)
        }
        get {
            return defaultsStandard.value(forKey: PreferencesKeys.preference_lifecycle_first_install) as? Date
        }
    }
    
    public var firstComputation: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_lifecycle_first_computation)
        }
        get {
            return defaultsStandard.value(forKey: PreferencesKeys.preference_lifecycle_first_computation) as? Date
        }
    }
    
    public var welcomeShown: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_lifecycle_welcome_shown_key)
        }
        get {
            return defaultsStandard.bool(forKey: PreferencesKeys.preference_lifecycle_welcome_shown_key)
        }
    }
    
    public var tourShown: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_lifecycle_tour_shown_key)
        }
        get {
            return defaultsStandard.bool(forKey: PreferencesKeys.preference_lifecycle_tour_shown_key)
        }
    }
    
    public var onboardingshown: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_lifecycle_onboarding_shown_key)
        }
        get {
            return defaultsStandard.bool(forKey: PreferencesKeys.preference_lifecycle_onboarding_shown_key)
        }
    }
    
    public var isPrivacyPolicyAccepted: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_lifecycle_privacy_policy_accepted_key)
        }
        get {
            return defaultsStandard.bool(forKey: PreferencesKeys.preference_lifecycle_privacy_policy_accepted_key)
        }
    }
    
    public var notificationScheduled: String {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_lifecycle_notification_scheduled)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_lifecycle_notification_scheduled) ?? Constants.EMPTY) as! String
        }
    }
    
    public func logout() {
        firstInstall = nil
        firstComputation = nil
        tourShown = false
        onboardingshown = false
        isPrivacyPolicyAccepted = false
        notificationScheduled = Constants.EMPTY
        welcomeShown = false
    }
}
