//
//  HealthResponseController.swift
//  App
//
//  Created by George Stavrou on 12/07/2023.
//

import UIKit

class HealthResponseController: BaseController {
    
    
    @IBOutlet var toolbar: Toolbar!
    
    @IBOutlet var screenTitle: BaseLabel!
    
    @IBOutlet var panel: BaseView!
    
    @IBOutlet var scrollview: BaseScrollView!
    
    @IBOutlet var timestamp: BaseLabel!
    
    @IBOutlet var mobilityResponse: HealthResponseComponent!
    
    @IBOutlet var selfcareResponse: HealthResponseComponent!
    
    @IBOutlet var usualActivitiesResponse: HealthResponseComponent!
    
    @IBOutlet var painResponse: HealthResponseComponent!
    
    
    @IBOutlet var anxietyResponse: HealthResponseComponent!
    
    @IBOutlet var healthScore: BaseLabel!
    
    @IBOutlet var healthScoreProgress: HorizontalProgressBar!
    
    var healthType: HealthType = HealthType.UNDEFINED
    fileprivate var healthResponse: DBHealth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        let modelId = controllerBoundle.getString(Extra.IDENTIFIER.key)
        if !TextUtils.isEmpty(modelId) {
            healthResponse = TableHealth.getById(modelId!)
            if healthResponse?.isValid() != true {
                Logger.e("Model is not valid on on \(className)")
                Toast.showShortToast(self.view, StringProvider.get("health_show_error"))
                return
            } else {
                prepare()
                setOnClickListeners()
            }
        } else {
            Logger.e("Model id is null on \(className)")
            Toast.showShortToast(self.view, StringProvider.get("health_show_error"))
            return
        }
    }
    
    func prepare() {
        
        healthType = HealthType.PAIN
        panel.cornerRadius = 10
        
        timestamp.text = TimeUtils.format(TimeUtils.getCurrent(healthResponse!.healthTimestamp), Constants.DATE_FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND, convertToDefault: true)
        
        mobilityResponse.setLayout(HealthType.MOBILITY.title, HealthType.getResponse(String(healthResponse!.healthMobility), HealthType.MOBILITY))
        selfcareResponse.setLayout(HealthType.SELF_CARE.title, HealthType.getResponse(String(healthResponse!.healthSelfCare), HealthType.SELF_CARE))
        usualActivitiesResponse.setLayout(HealthType.USUAL_ACTIVITIES.title, HealthType.getResponse(String(healthResponse!.healthActivities), HealthType.USUAL_ACTIVITIES))
        painResponse.setLayout(HealthType.PAIN.title, HealthType.getResponse(String(healthResponse!.healthPain), HealthType.PAIN))
        anxietyResponse.setLayout(HealthType.ANXIETY.title, HealthType.getResponse(String(healthResponse!.healthAnxiety), HealthType.ANXIETY))
        
        healthScoreProgress.setBackgroundLineColorOne(ColorProvider.get("colorSecondaryLight"))
        healthScoreProgress.setBackgroundLineColorTwo(ColorProvider.get("colorSecondaryLight"))
        healthScoreProgress.setProgressLineColorOne(ColorProvider.get("colorPrimary"))
        healthScoreProgress.setProgressLineColorTwo(ColorProvider.get("colorSecondary"))
        healthScoreProgress.setLineWidth(CGFloat(20))
        healthScoreProgress.hideProgressIcon()
        healthScoreProgress.setMaxProgress(CGFloat(Constants.HEALTH_MAX_PROGRESS))
        healthScoreProgress.setProgress(CGFloat(healthResponse!.healthScore))
        
        healthScore.text = String(format: StringProvider.get("health_score_label"), String(healthResponse!.healthScore))
    }
    
    private func setOnClickListeners() {
        
        mobilityResponse.checkbox.setOnCheckedChangedListener({ isChecked in
            self.mobilityResponse.checkbox.isChecked = true
            Toast.showShortToast(self.view, "Your answer cannot change")
        })
        
        selfcareResponse.checkbox.setOnCheckedChangedListener({ isChecked in
            self.selfcareResponse.checkbox.isChecked = true
            Toast.showShortToast(self.view, "Your answer cannot change")
        })
        
        usualActivitiesResponse.checkbox.setOnCheckedChangedListener({ isChecked in
            self.usualActivitiesResponse.checkbox.isChecked = true
            Toast.showShortToast(self.view, "Your answer cannot change")
        })
        
        anxietyResponse.checkbox.setOnCheckedChangedListener({ isChecked in
            self.anxietyResponse.checkbox.isChecked = true
            Toast.showShortToast(self.view, "Your answer cannot change")
        })
        
        painResponse.checkbox.setOnCheckedChangedListener({ isChecked in
            self.painResponse.checkbox.isChecked = true
            Toast.showShortToast(self.view, "Your answer cannot change")
        })
    }
}
