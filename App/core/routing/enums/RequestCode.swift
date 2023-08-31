//
//  RequestCode.swift
//  BaseApp
//
//  Created by Omar Brugna on 12/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public enum RequestCode {
    
    case VOTE // DEMO_CODE!
    
    public var value: Int {
        switch self {
            case .VOTE: return 99 // DEMO_CODE!
        }
    }
}
