//
//  UserManager.swift
//  App
//
//  Created by Omar Brugna on 14/04/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

public class UserManager {

    static func registerUser(_ controller: BaseController, _ request: UserRegistrationRequest, _ listener: UserRegistrationListener? = nil) {
        if !request.isValid() {
            Logger.e("Invalid user registration request")
            
            if TextUtils.isEmpty(request.phoneModel) {
                listener?.onError(message: "Error: the phone model is null")
            } else if TextUtils.isEmpty(request.appVersion) {
                listener?.onError(message: "Error: the app version is null")
            } else if TextUtils.isEmpty(request.androidVersion) {
                listener?.onError(message: "Error: the system version is null")
            } else if request.userNhsNumber == nil {
                listener?.onError(message: "Error: the user nhs number is null")
            } else if TextUtils.isEmpty(request.userSex) {
                listener?.onError(message: "Error: the user sex is null")
            } else if TextUtils.isEmpty(request.userFirstName) {
                listener?.onError(message: "Error: the user first name is null")
            } else if TextUtils.isEmpty(request.userLastName) {
                listener?.onError(message: "Error: the user last name is null")
            } else if TextUtils.isEmpty(request.userConsentName) {
                listener?.onError(message: "Error: the user consent name is null")
            } else if TextUtils.isEmpty(request.userIPAddress) {
                listener?.onError(message: "Error: the ip address is null")
            } else if TextUtils.isEmpty(request.userIPAddress) {
                listener?.onError(message: "Error: the postcode is null")
            } else if TextUtils.isEmpty(request.userEmail) {
                listener?.onError(message: "Error: the user email is null")
            } else if TextUtils.isEmpty(request.userPhoneNumber) {
                listener?.onError(message: "Error: the user phone number is null")
            } else if request.userDob == nil {
                listener?.onError(message: "Error: the date of birthday is null")
            } else if request.userConsentDate == nil {
                listener?.onError(message: "Error: the date of consent is null")
            } else if request.registrationTimestamp == nil {
                listener?.onError(message: "Error: the date of registration is null")
            } else {
                listener?.onError(message: "Error: the registration failed")
            }
            return
        }
        
        let webService = WebService<UserRegistrationRequest>(.USER_REGISTRATION)
        webService.method = .post
        webService.params = request
        
        Connection(webService, { tag, connectionResult, response in
            switch connectionResult {
                case .SUCCESS:
                    if !TextUtils.isEmpty(response) {
                        let map: UserRegistrationMap? = Gson.toObject(response!)
                        if map != nil {
                            if map!.isValid() {
                                listener?.onSuccess(request, map!)
                            } else {
                                Logger.d("Error registering user \(map!.dataItem?.userId?.id ?? Constants.EMPTY)")
                                listener?.onError(message: "Error: the server rejected the request, please try again")
                            }
                        } else {
                            Logger.e("Error registering user json response")
                            listener?.onError(message: "Error: the server response is invalid, please try again")
                        }
                    } else {
                        Logger.e("Error registering user json response")
                        listener?.onError(message: "Error: the server response is null, please try again")
                    }
                case .ERROR:
                    Logger.e("Registering user to server error")
                    listener?.onError(message: "Error: the request failed, please try again")
                default:
                    break
            }
        }).connect()
    }
}
