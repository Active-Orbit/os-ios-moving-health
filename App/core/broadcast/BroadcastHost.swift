//
//  BroadcastHost.swift
//  App
//
//  Created by Omar Brugna on 26/04/21.
//

import Foundation

public protocol BroadcastHost {

    func broadcastRegister(_ broadcast: BaseBroadcast)

    func broadcastUnregister()

    func broadcastIdentifier() -> Int
}
