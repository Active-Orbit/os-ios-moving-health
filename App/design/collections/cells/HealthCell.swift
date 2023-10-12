//
//  HealthCell.swift
//  App
//
//  Created by George Stavrou on 26/07/2023.
//

import UIKit

class HealthCell : BaseCollectionViewCell {
    

    @IBOutlet var container: BaseView!
    
    @IBOutlet var iconView: BaseView!
    
    @IBOutlet var healthScore: BaseLabel!
    
    @IBOutlet var healthScoreProgressBar: HorizontalProgressBar!
    
    @IBOutlet var timestamp: BaseLabel!
    
    public static let IDENTIFIER = "HealthCell"

    public override func getXibName() -> String {
        return "HealthCell"
    }
    
    func setup(_ controller: BaseController, _ model: DBHealth) {
        
        container.cornerRadius = 10
        container.borderWidth = 1
        container.borderColor = ColorProvider.get("colorPrimary")
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 10
        iconView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        
        
        healthScore.text = String(format: StringProvider.get("health_score_label"), String(model.healthScore))
        timestamp.text = TimeUtils.format(TimeUtils.getCurrent(model.healthTimestamp), Constants.DATE_FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND, convertToDefault: false)
        
        
        healthScoreProgressBar.setBackgroundLineColorOne(ColorProvider.get("colorSecondaryLight"))
        healthScoreProgressBar.setBackgroundLineColorTwo(ColorProvider.get("colorSecondaryLight"))
        healthScoreProgressBar.setProgressLineColorOne(ColorProvider.get("colorPrimary"))
        healthScoreProgressBar.setProgressLineColorTwo(ColorProvider.get("colorSecondary"))
        healthScoreProgressBar.setLineWidth(CGFloat(20))
        healthScoreProgressBar.hideProgressIcon()
        healthScoreProgressBar.setMaxProgress(CGFloat(Constants.HEALTH_MAX_PROGRESS))
        healthScoreProgressBar.setProgress(CGFloat(model.healthScore))
        

        clickListener = {
            let boundle = Boundle()
            boundle.putString(Extra.IDENTIFIER.key, model.healthID)
            Router.instance
                .controllerTransition(ControllerTransition.LEFT_TO_RIGHT)
                .startBaseController(controller, Controllers.HEALTH_RESPONSE, boundle)
        }
    }
}
