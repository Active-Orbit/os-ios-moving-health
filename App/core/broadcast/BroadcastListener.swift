//
//  BroadcastListener.swift
//  App
//
//  Created by Omar Brugna on 26/04/21.
//  Copyright © 2021 Active Orbit. All rights reserved.
//

import Foundation

public protocol BroadcastListener {
    
    func onBroadcast(type: String, sentByMyself: Bool, identifier: String, subIdentifier: String)
}
