//
//  BottomNavItemType.swift
//  App
//
//  Created by George Stavrou on 25/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public enum BottomNavItemType: CaseIterable {
    
    case MAIN
    case TRIPS
    case HEALTH
    
    
    var id: Int {
        switch self {
            case .MAIN: return 0
            case .TRIPS: return 1
            case .HEALTH: return 2
          
        }
    }
    
    public static func getById(_ id: Int) -> BottomNavItemType {
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        return MAIN
    }
}
