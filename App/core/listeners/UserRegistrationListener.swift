//
//  UserRegistrationListener.swift
//  App
//
//  Created by Omar Brugna on 14/04/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

protocol UserRegistrationListener {

    func onSuccess(_ request: UserRegistrationRequest, _ map: UserRegistrationMap)

    func onError(message: String)
}
