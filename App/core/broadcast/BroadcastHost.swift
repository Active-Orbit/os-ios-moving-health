//
//  BroadcastHost.swift
//  App
//
//  Created by Omar Brugna on 26/04/21.
//  Copyright © 2021 Active Orbit. All rights reserved.
//

import Foundation

public protocol BroadcastHost {

    func broadcastRegister(_ broadcast: BaseBroadcast)

    func broadcastUnregister()

    func broadcastIdentifier() -> Int
}
