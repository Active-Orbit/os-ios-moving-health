//
//  NotificationType.swift
//  App
//
//  Created by Omar Brugna on 22/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

public enum NotificationType: CaseIterable {
    
    case UNDEFINED
    case HEALTH
    
    public var id: String {
        switch self {
            case .UNDEFINED: return "0"
            case .HEALTH: return "1"
        }
    }
    
    public var channelName: String {
        switch self {
            case .UNDEFINED: return Constants.EMPTY
            case .HEALTH: return "Health"
        }
    }
    
    public var channelImportance: Int {
        switch self {
            case .UNDEFINED: return 0
            case .HEALTH: return 1
        }
    }
    
    public var title: String {
        switch self {
            case .UNDEFINED: return Constants.EMPTY
            case .HEALTH: return "How is your health today?"
        }
    }
    
    public var body: String {
        switch self {
            case .UNDEFINED: return Constants.EMPTY
            case .HEALTH: return "Complete the questionnaire to let us know how you feel today?"
        }
    }
    
    public var smallIcon: String {
        switch self {
            case .UNDEFINED: return Constants.EMPTY
            case .HEALTH: return "ic_activity"
        }
    }
    
    //TODO add correct notification logo
    public var largeIcon: String {
        switch self {
            case .UNDEFINED: return Constants.EMPTY
            case .HEALTH: return "ic_activity"
                
        }
    }
    
    public var color: String {
        switch self {
            case .UNDEFINED: return Constants.EMPTY
            case .HEALTH: return "colorPrimary"
        }
    }
    
    public static func getById(_ id: String) -> NotificationType {
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        return UNDEFINED
    }
    
    public static func getAll() -> [NotificationType] {
        return allCases
    }
    
    public static func getRandomNotification(_ scheduledNotification: NotificationType) -> NotificationType {
        let randomNotification = allCases.randomElement() ?? UNDEFINED
        if randomNotification == UNDEFINED || randomNotification == scheduledNotification {
            return getRandomNotification(scheduledNotification)
        }
        return randomNotification
    }
}
