//
//  BackendPreferences.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class BackendPreferences : BasePreferences {
    
    public var baseUrl: String {
        set {
            defaultsStandard.setValue(newValue, forKey: PreferencesKeys.preference_backend_base_url)
        }
        get {
            return (defaultsStandard.value(forKey: PreferencesKeys.preference_backend_base_url) ?? Constants.EMPTY) as! String
        }
    }
    
    public func logout() {
        // baseUrl = Constants.EMPTY
    }
}
