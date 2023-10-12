//
//  Constants.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

/**
 * Utility class that provides some useful constant values
 */
public class Constants {
    
    public static let EMPTY = ""
    public static let INVALID = -1
    public static let INVALID_DOUBLE = 0.0
    
    public static let DATABASE_ENCRYPTION_KEY = "000Th3D4t4b4s31s3ncrYpt3d?000"
    
    public static let DATE_FORMAT_ID = "yyyyMMddHHmmss"
    public static let DATE_FORMAT_UTC = "yyyy-MM-dd HH:mm:ss"
    public static let DATE_FORMAT_ISO = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    public static let DATE_FORMAT_ISO_NO = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    public static let DATE_FORMAT_ISO_MILLIS = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
    public static let DATE_FORMAT_FULL = "dd/MM/yyyy HH:mm:ss"
    public static let DATE_FORMAT_DAY_MONTH_YEAR = "dd/MM/yyyy"
    public static let DATE_FORMAT_DAY_MONTH = "dd\nMMM"
    public static let DATE_FORMAT_HOUR_MINUTE = "HH:mm"
    public static let DATE_FORMAT_HOUR_MINUTE_SECOND = "HH:mm:ss"
    public static let DATE_FORMAT_MONTH_YEAR = "MMMM yyyy"
    public static let DATE_FORMAT_YEAR_MONTH_DAY = "yyyy-MM-dd"
    public static let DATE_FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND = DATE_FORMAT_UTC

    public static let HEALTH_RESPONSE_ONE_ID = "1"
    public static let HEALTH_RESPONSE_TWO_ID = "2"
    public static let HEALTH_RESPONSE_THREE_ID = "3"
    public static let HEALTH_RESPONSE_FOUR_ID = "4"
    public static let HEALTH_RESPONSE_FIVE_ID = "5"
    
    public static let ALPHA_ENABLED: CGFloat = 1.0
    public static let ALPHA_DISABLED: CGFloat = 0.5
    public static let ALPHA_PRESSED: CGFloat = 0.5
    
    public static let PROGRESS_ANIMATION_DURATION = 1000
    public static let PROGRESS_ANIMATION_INCREMENT = 15
    public static let NHS_WEEK_HEART_TARGET = 10
    public static let HEALTH_MAX_PROGRESS = 100
    
    public static let ANIMATION_DURATION_HORIZONTAL = 1.5
    public static let ANIMATION_DURATION_VERTICAL = 1.5
    public static let ANIMATION_DURATION_CIRCLE = 1.5
    
    #if !os(watchOS)
    public static let ANIMATION_TYPE_HORIZONTAL = CAMediaTimingFunction(name: .easeInEaseOut)
    public static let ANIMATION_TYPE_VERTICAL = CAMediaTimingFunction(name: .linear)
    public static let ANIMATION_TYPE_CIRCLE = CAMediaTimingFunction(name: .easeInEaseOut)
    #endif
    
    public static let CONTROLLER_TRANSITION_DURATION = 0.3
    
    public static let ALIGN_TEXT_CENTER = "center"
    public static let ALIGN_TEXT_LEFT = "left"
    public static let ALIGN_TEXT_RIGHT = "right"
}
