//
//  UserRegistrationRequest.swift
//  App
//
//  Created by Omar Brugna on 14/04/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

public class UserRegistrationRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case phoneModel
        case appVersion
        case androidVersion
        case userNhsNumber
        case userFirstName
        case userLastName
        case userDob
        case userPostcode
        case userIPAddress
        case userConsentDate
        case userConsentName
        case userEmail
        case userPhoneNumber
        case userSex
        case registrationTimestamp
        
        var rawValue: String {
            get {
                switch self {
                    case .phoneModel: return "phoneModel"
                    case .appVersion: return "appVersion"
                    case .androidVersion: return "androidVersion"
                    case .userNhsNumber: return "userNHSNumber"
                    case .userFirstName: return "userFirstName"
                    case .userLastName: return "userLastName"
                    case .userDob: return "userDateOfBirth"
                    case .userPostcode: return "userPostcode"
                    case .userIPAddress: return "userIPAddress"
                    case .userConsentDate: return "userConsentDate"
                    case .userConsentName: return "userConsentName"
                case .userEmail: return "userEmail"
                case .userPhoneNumber: return "userPhoneNumber"
                    case .userSex: return "userSex"
                    case .registrationTimestamp: return "timeInMsecs"
                }
            }
        }
    }
    
    var phoneModel: String?
    var appVersion: String?
    var androidVersion: String?
    var userNhsNumber: Int?
    var userFirstName: String?
    var userLastName: String?
    var userDob: Double?
    var userPostcode: String?
    var userIPAddress: String?
    var userConsentDate: Double?
    var userConsentName: String?
    var userEmail: String?
    var userPhoneNumber: String?
    var userSex: String?
    var registrationTimestamp: Double?
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(phoneModel) &&
        !TextUtils.isEmpty(appVersion) &&
        !TextUtils.isEmpty(androidVersion) &&
        userNhsNumber != nil &&
        !TextUtils.isEmpty(userSex) &&
        !TextUtils.isEmpty(userFirstName) &&
        !TextUtils.isEmpty(userLastName) &&
        !TextUtils.isEmpty(userConsentName) &&
        !TextUtils.isEmpty(userIPAddress) &&
        !TextUtils.isEmpty(userPostcode) &&
        (!TextUtils.isEmpty(userEmail) || !TextUtils.isEmpty(userPhoneNumber)) &&
        userDob != nil &&
        userConsentDate != nil &&
        registrationTimestamp != nil
    }
    
    public func toJson() -> String? {
        return Gson.toJsonString(self)
    }
}
