//
//  BroadcastListener.swift
//  App
//
//  Created by Omar Brugna on 26/04/21.
//

import Foundation

public protocol BroadcastListener {
    
    func onBroadcast(type: String, sentByMyself: Bool, identifier: String, subIdentifier: String)
}
