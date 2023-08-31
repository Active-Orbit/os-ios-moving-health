//
//  ActivityCell.swift
//  App
//
//  Created by Omar Brugna on 01/08/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

class ActivityCell : BaseCollectionViewCell {
    
    @IBOutlet var container: BaseView!
    @IBOutlet var activityIcon: BaseImageView!
    @IBOutlet var activityIconContainer: BaseView!
    @IBOutlet var activityName: BaseLabel!
    @IBOutlet var activityTime: BaseLabel!
    @IBOutlet var activityDetails: BaseLabel!
    @IBOutlet var activityMap: BaseImageView!
    @IBOutlet var activityMapContainer: BaseView!
    @IBOutlet var connector1: UIView!
    @IBOutlet var connector2: UIView!
    
    public static let IDENTIFIER = "ActivityCell"

    public override func getXibName() -> String {
        return "ActivityCell"
    }
    
    override func onViewPrepared() {
        super.onViewPrepared()
        
        container.cornerRadius = 10
        container.borderWidth = 1
        container.borderColor = ColorProvider.get("colorPrimary")
        
        activityMapContainer.clipsToBounds = true
        activityMapContainer.layer.cornerRadius = 10
        activityMapContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func setup(_ controller: BaseController, _ model: TrackerDBSegment, _ models: [TrackerDBSegment], _ position: Int) {
        
        activityIcon.image = ActivityUtils.getIcon(model.type)
        activityName.text = ActivityUtils.getName(model.type).capitalizeFirstLetter()
        
        var timeString = Constants.EMPTY
        let startDate = model.startDate
        if startDate != nil {
            timeString += TimeUtils.format(startDate!, Constants.DATE_FORMAT_HOUR_MINUTE, convertToDefault: true)
        } else {
            timeString += StringProvider.get("not_available")
        }
        
        timeString += " - "
        
        let endDate = model.endDate
        if endDate != nil {
            timeString += TimeUtils.format(endDate!, Constants.DATE_FORMAT_HOUR_MINUTE, convertToDefault: true)
        } else {
            timeString += StringProvider.get("not_available")
        }
        
        activityTime.text = timeString
        
        if model.type == TrackerActivityType.WALKING.id || model.type == TrackerActivityType.RUNNING.id {
            activityDetails.visibility = .visible
            var speed: Double = 0
            if model.activityDuration > 0 {
                if model.distanceTravelled > 0 {
                    speed = Double(model.distanceTravelled) / Double(model.activityDuration)
                } else {
                    speed = (Double(model.steps) * 0.8) / Double(model.activityDuration)
                }
            }
            activityDetails.text = String(format: StringProvider.get("activity_details"), String(model.steps), String(format: "%.2f", speed))
        } else {
            activityDetails.clear()
            activityDetails.visibility = .invisible
        }
        
        if position == models.count - 1 {
            connector1.visibility = .invisible
            connector2.visibility = .invisible
        } else {
            connector1.visibility = .visible
            connector2.visibility = .visible
        }

        clickListener = {
            let boundle = Boundle()
            boundle.putExtra(Extra.MODELS.key, models)
            boundle.putInt(Extra.POSITION.key, position)
            Router.instance.startBaseController(controller, Controllers.MAP, boundle)
        }
    }
}
