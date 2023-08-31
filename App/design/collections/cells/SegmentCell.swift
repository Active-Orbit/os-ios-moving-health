//
//  SegmentCell.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

class SegmentCell : BaseCollectionViewCell {
    
    @IBOutlet weak var container: BaseView!
    @IBOutlet weak var segmentDateStart: BaseLabel!
    @IBOutlet weak var segmentDateEnd: BaseLabel!
    @IBOutlet weak var segmentDuration: BaseLabel!
    @IBOutlet weak var segmentBrisk: BaseLabel!
    @IBOutlet weak var segmentIcon: BaseImageView!
    
    public static let IDENTIFIER = "SegmentCell"
    
    public override func getXibName() -> String {
        return "SegmentCell"
    }
    
    override func onViewPrepared() {
        super.onViewPrepared()
        
        container.cornerRadius = 40
        container.borderWidth = 1
        container.borderColor = ColorProvider.get("colorGray")
        container.backgroundColor = ColorProvider.get("white")
    }
    
    func setup(_ controller: BaseController, _ model: TrackerDBSegment) {
        
        let startDate = model.startDate
        if startDate != nil {
            segmentDateStart.text = TimeUtils.format(startDate!, Constants.DATE_FORMAT_HOUR_MINUTE_SECOND, convertToDefault: true)
        } else {
            segmentDateStart.text = StringProvider.get("not_available")
        }
        
        let endDate = model.endDate
        if endDate != nil {
            segmentDateEnd.text = TimeUtils.format(endDate!, Constants.DATE_FORMAT_HOUR_MINUTE_SECOND, convertToDefault: true)
        } else {
            segmentDateEnd.text = StringProvider.get("not_available")
        }
        
        segmentDuration.text = String(model.activityDuration / 60) + " Minutes | " + String(model.steps) + " Steps"
        
        if model.type != TrackerActivityType.CYCLING.id {
            if model.numberOfBriskChunks != TrackerConstants.INVALID {
                segmentBrisk.text = String(model.numberOfBriskChunks) + " Heart"
            } else {
                segmentBrisk.text = "0 Heart"
            }
        } else {
            segmentBrisk.text = String(model.activityDuration / 60) + " Heart"
        }
        
        switch model.type {
            case TrackerActivityType.WALKING.id:
                segmentIcon.image = ImageProvider.get("ic_segment_walking")
            case TrackerActivityType.RUNNING.id:
                segmentIcon.image = ImageProvider.get("ic_segment_running")
            case TrackerActivityType.CYCLING.id:
                segmentIcon.image = ImageProvider.get("ic_segment_cycling")
            case TrackerActivityType.AUTOMOTIVE.id:
                segmentIcon.image = ImageProvider.get("ic_segment_vehicle")
            default:
                segmentIcon.image = ImageProvider.get("ic_segment_stationary")
        }
    }
}
