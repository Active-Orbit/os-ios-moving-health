//
//  BasePreferences.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import Foundation

public class BasePreferences {
    
    public static func logout() {
        Preferences.backend.logout()
        Preferences.lifecycle.logout()
        Preferences.user.logout()
    }
    
    public static func printAll() {
        Logger.d("Stored Preferences")
        for preference in UserDefaults.standard.dictionaryRepresentation() {
            if preference.key.starts(with: PreferencesKeys.prefix) {
                Logger.d("\(preference.key) : \(preference.value)")
            }
        }
    }
}
