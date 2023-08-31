//
//  ActivityPanelComponent.swift
//  App
//
//  Created by Omar Brugna on 26/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class ActivityPanelComponent: BaseComponent {
    
    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var panelTitle: BaseLabel!
    @IBOutlet weak var walkingLabel: BaseLabel!
    @IBOutlet weak var stepsLabel: BaseLabel!
    @IBOutlet weak var cyclingLabel: BaseLabel!
    @IBOutlet weak var progressCircular: CircularProgressBar!
    @IBOutlet weak var heartLabel: BaseLabel!
    @IBOutlet weak var progressHorizontal: HorizontalProgressBar!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        mainView.cornerRadius = 16
        
        progressCircular.setBackgroundLineColor(ColorProvider.get("colorPrimaryLight"))
        progressCircular.setProgressLineColor(ColorProvider.get("colorAccent"))
        progressCircular.setLineWidth(40)
        progressCircular.setMaxProgress(CGFloat(100))
        
        progressHorizontal.setBackgroundLineColorOne(ColorProvider.get("colorPrimaryLight"))
        progressHorizontal.setBackgroundLineColorTwo(ColorProvider.get("colorPrimaryLight"))
        progressHorizontal.setProgressLineColorOne(ColorProvider.get("colorAccent"))
        progressHorizontal.setProgressLineColorTwo(ColorProvider.get("colorAccent"))
        progressHorizontal.setLineWidth(40)
        progressHorizontal.setMaxProgress(CGFloat(100))
    }
    
    public override func getXibName() -> String {
        return "ActivityPanelComponent"
    }
    
    public func setProgress(_ minutesWalking: Int, _ minutesHeart: Int, _ minutesCycling: Int, _ distanceWalking: Double, _ distanceHeart: Double, _ distanceCycling: Double, _ steps: Int) {
        
        progressCircular.setProgress(CGFloat(minutesWalking))
        
        if (minutesHeart >= 100) {
            progressHorizontal.setProgress(CGFloat(100))
        } else {
            progressHorizontal.setProgress(CGFloat(minutesHeart))
        }
        

        if minutesWalking == 1 { walkingLabel.text = StringProvider.get("activity_distance_active_minute") }
        else { walkingLabel.text = String(format: StringProvider.get("activity_distance_active_minutes"), String(minutesWalking), String(format: "%.1f", distanceWalking)) }
        
        if minutesHeart == 1 { heartLabel.text = StringProvider.get("activity_distance_heart_minute") }
        else { heartLabel.text = String(format: StringProvider.get("activity_distance_heart_minutes"), String(minutesHeart)) }
        
        if minutesCycling == 1 { cyclingLabel.text = StringProvider.get("activity_distance_cycling_minute") }
        else { cyclingLabel.text = String(format: StringProvider.get("activity_distance_cycling_minutes"), String(minutesCycling), String(format: "%.1f", distanceCycling)) }
        
        if steps == 1 { stepsLabel.text = StringProvider.get("activity_step") }
        else { stepsLabel.text = String(format: StringProvider.get("activity_steps"), String(steps)) }
    }
    
    public override func setOnClickListener(_ listener: @escaping (() -> Void)) {
        super.setOnClickListener(listener)
        mainView.setOnClickListener(listener)
    }
}
