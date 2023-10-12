//
//  UserRegistrationListener.swift
//  App
//
//  Created by Omar Brugna on 14/04/23.
//

import Foundation

protocol UserRegistrationListener {

    func onSuccess(_ request: UserRegistrationRequest, _ map: UserRegistrationMap)

    func onError(message: String)
}
