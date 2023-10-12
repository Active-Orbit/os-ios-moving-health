//
//  Api.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import Foundation

/**
 * Utility class to declare api urls
 */
public class Api : Equatable {
    
    public static var EMPTY = Api(Constants.EMPTY)
    public static var INSERT_HEALTH = Api("v2/user_health_questionnaire")
    public static var INSERT_SYMPTOMS = Api("insert_symptoms")
    public static var RETRIEVE_CONSENT_FORM = Api("v2/user_consent_form")
    public static var USER_REGISTRATION = Api("v2/user_registration")
    
    fileprivate var url: String
    fileprivate var params = [String]()
    
    fileprivate init(_ url: String) {
        self.url = url
    }
    
    public func clearParams() {
        params.removeAll()
    }

    public func addParam(_ param: String) {
        params.append(param)
    }

    public func getUrl() -> String {
        if params.isEmpty { return url }
        if params.count == 1 { return String(format: url, params[0]) }
        if params.count == 2 { return String(format: url, params[0], params[1]) }
        if params.count == 3 { return String(format: url, params[0], params[1], params[2]) }
        if params.count == 4 { return String(format: url, params[0], params[1], params[2], params[3]) }
        if params.count == 5 { return String(format: url, params[0], params[1], params[2], params[3], params[4]) }
        Exception("Current implementation actually supports at least 5 parameters, please add the new cases")
        return Constants.EMPTY
    }
    
    public static func == (lhs: Api, rhs: Api) -> Bool {
        return lhs.url == rhs.url
    }
}
