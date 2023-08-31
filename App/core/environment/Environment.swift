//
//  Environment.swift
//  App
//
//  Created by Omar Brugna on 04/04/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

/*
 Utility class to manage environment variables
 */
public class Environment {
    
    fileprivate static let appName = "AppName"
    fileprivate static let baseUrl = "BaseUrl"
    fileprivate static let googleApiKey = "GoogleApiKey"
    
    public static let APP_NAME = mainBundle.infoDictionary?[appName] as! String
    public static let BASE_URL = mainBundle.infoDictionary?[baseUrl] as! String
    public static let GOOGLE_API_KEY = mainBundle.infoDictionary?[googleApiKey] as! String
}
