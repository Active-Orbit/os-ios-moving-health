//
//  ResultCode.swift
//  BaseApp
//
//  Created by Omar Brugna on 12/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public enum ResultCode {
    
    case RESULT_OK
    case RESULT_CANCELED
    case RESULT_DELETED
    
    public var value: Int {
        switch self {
            case .RESULT_OK: return -1
            case .RESULT_CANCELED: return 0
            case .RESULT_DELETED: return 2
        }
    }
}
