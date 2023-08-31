//
//  ControllerTransition.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public enum ControllerTransition {
    case FADE
    case LEFT_TO_RIGHT
    case BOTTOM_TO_TOP
    case DEFAULT
    
    var value: Int {
        switch self {
            case .FADE: return 1
            case .LEFT_TO_RIGHT: return 2
            case .BOTTOM_TO_TOP: return 3
            case .DEFAULT: return ControllerTransition.FADE.value
        }
    }
}
