//
//  DebugCell.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

class DebugCell : BaseCollectionViewCell {
    
    @IBOutlet weak var container: BaseView!
    @IBOutlet weak var debugDateStart: BaseLabel!
    @IBOutlet weak var debugDateEnd: BaseLabel!
    @IBOutlet weak var debugDuration: BaseLabel!
    @IBOutlet weak var debugSteps: BaseLabel!
    @IBOutlet weak var debugIcon: BaseImageView!
    
    public static let IDENTIFIER = "DebugCell"
    
    public override func getXibName() -> String {
        return "DebugCell"
    }
    
    override func onViewPrepared() {
        super.onViewPrepared()
        
        container.cornerRadius = 40
        container.borderWidth = 1
        container.borderColor = ColorProvider.get("colorGray")
        container.backgroundColor = ColorProvider.get("white")
    }
    
    func setup(_ controller: BaseController, _ model: TrackerDBActivity) {
        
        let startDate = model.startDate
        if startDate != nil {
            debugDateStart.text = TimeUtils.format(startDate!, Constants.DATE_FORMAT_HOUR_MINUTE_SECOND, convertToDefault: true)
        } else {
            debugDateStart.text = StringProvider.get("not_available")
        }
        
        let endDate = model.endDate
        if endDate != nil {
            debugDateEnd.text = TimeUtils.format(endDate!, Constants.DATE_FORMAT_HOUR_MINUTE_SECOND, convertToDefault: true)
        } else {
            debugDateEnd.text = StringProvider.get("not_available")
        }
        
        debugDuration.text = String(model.duration() / 60) + " Minutes"
        debugSteps.text = String(model.steps) + " Steps"
        
        switch model.activityType {
            case TrackerActivityType.WALKING.id:
                debugIcon.image = ImageProvider.get("ic_segment_walking")
            case TrackerActivityType.RUNNING.id:
                debugIcon.image = ImageProvider.get("ic_segment_running")
            case TrackerActivityType.CYCLING.id:
                debugIcon.image = ImageProvider.get("ic_segment_cycling")
            case TrackerActivityType.AUTOMOTIVE.id:
                debugIcon.image = ImageProvider.get("ic_segment_vehicle")
            default:
                debugIcon.image = ImageProvider.get("ic_segment_stationary")
        }
    }
}
