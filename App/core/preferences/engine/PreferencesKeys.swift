//
//  PreferencesKeys.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class PreferencesKeys {
    
    public static let prefix = "base.app."
    
    // backend preferences
    public static let preference_backend_base_url = prefix + "backend.base.url"
    
    // user preferences
    public static let preference_user_id_user_key = prefix + "id.user"
    public static let preference_user_id_patient_key = prefix + "user.id.patient"
    public static let preference_user_id_program_key = prefix + "user.id.program"
    public static let preference_user_study_started_key = prefix + "user.study.started"
    public static let preference_user_watch_synchronized_key = prefix + "watch.synchronized"
    public static let preference_user_date_study_started_key = prefix + "user.date.study.started"
    public static let preference_user_sex_key = prefix + "user.sex"
    public static let preference_user_age_key = prefix + "user.age"
    public static let preference_user_weight_key = prefix + "user.weight"
    public static let preference_user_height_key = prefix + "user.height"
    public static let preference_user_date_of_birth_key = prefix + "user.date.of.birth"
    public static let preference_user_first_name_key = prefix + "user.first.name"
    public static let preference_user_last_name_key = prefix + "user.last.name"
    public static let preference_user_consent_date_key = prefix + "user.consent.date"
    public static let preference_user_postcode_key = prefix + "user.postcode"
    public static let preference_user_email_key = prefix + "user.email"
    public static let preference_user_phone_key = prefix + "user.phone"
    public static let preference_user_consent_name_key = prefix + "user.consent.name"
    public static let preference_user_consent_form_text_key = prefix + "user.consent.form.text"
    public static let preference_user_consent_form_version_key = prefix + "user.consent.form.version"
    public static let preference_user_push_token = prefix + "user.push.token"
    
    // lifecycle preferences
    public static let preference_lifecycle_first_install = prefix + "lifecycle.first.install"
    public static let preference_lifecycle_first_computation = prefix + "lifecycle.first.computation"
    public static let preference_lifecycle_welcome_shown_key = prefix + "lifecycle.welcome.shown"
    public static let preference_lifecycle_tour_shown_key = prefix + "lifecycle.onboarding.shown"

    public static let preference_lifecycle_onboarding_shown_key = prefix + "lifecycle.onboarding.shown"
    public static let preference_lifecycle_privacy_policy_accepted_key = prefix + "lifecycle.privacy.policy.accepted"
    public static let preference_lifecycle_terms_conditions_accepted_key = prefix + "lifecycle.terms.conditions.accepted"
    public static let preference_lifecycle_notification_scheduled = prefix + "lifecycle.notification.scheduled"
}
