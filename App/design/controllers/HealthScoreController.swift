//
//  HealthScoreController.swift
//  App
//
//  Created by George Stavrou on 12/07/2023.
//

import UIKit

class HealthScoreController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    
    @IBOutlet var screenTitle: BaseLabel!
    @IBOutlet var panel: BaseView!
    @IBOutlet var panelDescription: BaseLabel!
    @IBOutlet var healthScore: BaseTextField!
    
    @IBOutlet var scrollview: BaseScrollView!
    
    @IBOutlet var stepOne: BaseView!
    @IBOutlet var stepTwo: BaseView!
    @IBOutlet var stepThree: BaseView!
    @IBOutlet var stepFour: BaseView!
    @IBOutlet var stepFive: BaseView!
    @IBOutlet var stepSix: BaseView!
    
    @IBOutlet var backButton: BaseButton!
    @IBOutlet var finishButton: BaseButton!
    
    @IBOutlet var bottomScrollVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var botttomSafeAreaConstranit: NSLayoutConstraint!
    
    var healthType: HealthType = HealthType.UNDEFINED
    var response = Constants.EMPTY
    var mobilityResponse = Constants.INVALID
    var selfcareResponse = Constants.INVALID
    var usualActivitiesResponse = Constants.INVALID
    var anxietyResponse = Constants.INVALID
    var painResponse = Constants.INVALID
    
    var healthModel: DBHealth? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        mobilityResponse = controllerBoundle.getInt(Extra.HEALTH_MOBILITY.key)
        selfcareResponse = controllerBoundle.getInt(Extra.HEALTH_SELF_CARE.key)
        usualActivitiesResponse = controllerBoundle.getInt(Extra.HEALTH_ACTIVITY.key)
        anxietyResponse = controllerBoundle.getInt(Extra.HEALTH_ANXIETY.key)
        painResponse = controllerBoundle.getInt(Extra.HEALTH_PAIN.key)
        
        prepare()
        setOnClickListeners()
        
        healthScore.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForKeyboardNotifications()
    }
    
    func prepare() {
        
        healthType = HealthType.SCORE
        
        panel.cornerRadius = 10
        stepOne.cornerRadius = 5
        stepTwo.cornerRadius = 5
        stepThree.cornerRadius = 5
        stepFour.cornerRadius = 5
        stepFive.cornerRadius = 5
        stepSix.cornerRadius = 5
        
        healthScore.cornerRadius = 10
        healthScore.borderWidth = 1
        healthScore.borderColor = ColorProvider.get("colorPrimaryDark")
        
        screenTitle.text = healthType.title
        panelDescription.text = HealthType.getDescription(healthType)
    }
    
    func setOnClickListeners() {
        
        backButton.setOnClickListener {
            self.finish()
        }
        
        finishButton.setOnClickListener {
            self.hideKeyboard()
            
            if self.isSelectionValid() {
                
                self.healthModel = DBHealth()
                self.healthModel!.healthID = String(Int(TimeUtils.getCurrent().timeInMillis))
                self.healthModel!.healthMobility = self.mobilityResponse
                self.healthModel!.healthSelfCare = self.selfcareResponse
                self.healthModel!.healthPain = self.painResponse
                self.healthModel!.healthActivities = self.usualActivitiesResponse
                self.healthModel!.healthAnxiety = self.anxietyResponse
                self.healthModel!.healthScore = Int(self.response) ?? Constants.INVALID
                self.healthModel!.healthTimestamp = TimeUtils.getCurrent().timeInMillis
                
                self.sendData()
            } else {
                Toast.showLongToast(self.view, StringProvider.get("health_add_score"))
            }
        }
    }
    
    private func isSelectionValid() -> Bool {
        response = self.healthScore.textTrim
        let responseInt = Int(response) ?? Constants.INVALID
        if response != Constants.EMPTY && responseInt >= 0 && responseInt <= 100 {
            return true
        }
        return false
    }
    
    private func sendData() {
        if self.healthModel!.isValid() {
            self.showProgressView()
            TableHealth.upsert(self.healthModel!)
            scheduleNotification()
            HealthManager.uploadHealth(self, self.healthModel!, { success in
                self.hideProgressView()
                if success {
                    Toast.showShortToast(self.view, StringProvider.get("success_health_report"))
                    Utils.delay(1500, runnable: {
                        let _ = Router.instance.backToController(self, Controllers.HEALTH)
                    })
                } else {
                    Toast.showShortToast(self.view, StringProvider.get("error"))
                    Utils.delay(1500, runnable: {
                        let _ = Router.instance.backToController(self, Controllers.HEALTH)
                    })
                }
            })
        } else {
            Toast.showShortToast(self.view, StringProvider.get("error"))
            Utils.delay(1500, runnable: {
                let _ = Router.instance.backToController(self, Controllers.HEALTH)
            })
        }
    }
    
    public override func keyboardWillShow(_ keyboardFrame: CGRect) {
        botttomSafeAreaConstranit.constant = keyboardFrame.size.height
        bottomScrollVerticalConstraint.priority = UILayoutPriority(999)
        botttomSafeAreaConstranit.priority = UILayoutPriority(1000)
        if healthScore.isFirstResponder {
            scrollview.scrollToView(healthScore, false)
        }
    }
    
    public override func keyboardWillHide(_ keyboardFrame: CGRect) {
        botttomSafeAreaConstranit.priority = UILayoutPriority(999)
        bottomScrollVerticalConstraint.priority = UILayoutPriority(1000)
    }
    
    fileprivate func scheduleNotification() {
        // schedule notification only if it has not been scheduled before
        let notificationToSchedule = NotificationType.HEALTH
        Preferences.lifecycle.notificationScheduled = notificationToSchedule.id
        let interval = Int((TimeUtils.ONE_DAY_MILLIS * 30) / TimeUtils.ONE_SECOND_MILLIS)
        NotificationManager.shared.scheduleNotification(interval: interval, notificationType: notificationToSchedule)
    }
}

extension HealthScoreController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        healthScore.borderColor = ColorProvider.get("colorSecondaryAccent")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        healthScore.borderColor = ColorProvider.get("colorPrimaryDark")
    }
}
