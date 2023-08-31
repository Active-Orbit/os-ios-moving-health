//
//  HealthAnxietyController.swift
//  App
//
//  Created by George Stavrou on 11/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

class HealthAnxietyController: BaseController {
    
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var screenTitle: BaseLabel!
    @IBOutlet var panel: BaseView!
    @IBOutlet var scrollview: BaseScrollView!
    
    @IBOutlet var panelDescription: BaseLabel!
    
    @IBOutlet var responseOne: CheckBoxComponent!
    @IBOutlet var responseTwo: CheckBoxComponent!
    @IBOutlet var responseThree: CheckBoxComponent!
    @IBOutlet var responseFour: CheckBoxComponent!
    @IBOutlet var responseFive: CheckBoxComponent!
    
    @IBOutlet var stepOne: BaseView!
    @IBOutlet var stepTwo: BaseView!
    @IBOutlet var stepThree: BaseView!
    @IBOutlet var stepFour: BaseView!
    @IBOutlet var stepFive: BaseView!
    @IBOutlet var stepSix: BaseView!
    
    @IBOutlet var nextButton: BaseButton!
    @IBOutlet var backButton: BaseButton!
    
    
    var healthType: HealthType = HealthType.UNDEFINED
    var response = Constants.INVALID
    var mobilityResponse = Constants.INVALID
    var selfcareResponse = Constants.INVALID
    var usualActivitiesResponse = Constants.INVALID
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        mobilityResponse = controllerBoundle.getInt(Extra.HEALTH_MOBILITY.key)
        selfcareResponse = controllerBoundle.getInt(Extra.HEALTH_SELF_CARE.key)
        usualActivitiesResponse = controllerBoundle.getInt(Extra.HEALTH_ACTIVITY.key)
        
        prepare()
        setOnClickListeners()
    }
    
    func prepare() {
        
        healthType = HealthType.ANXIETY
        
        panel.cornerRadius = 10
        stepOne.cornerRadius = 5
        stepTwo.cornerRadius = 5
        stepThree.cornerRadius = 5
        stepFour.cornerRadius = 5
        stepFive.cornerRadius = 5
        stepSix.cornerRadius = 5
        
        screenTitle.text = healthType.title
        panelDescription.text = HealthType.getDescription(healthType)
        responseOne.setLabel(HealthType.getResponse(Constants.HEALTH_RESPONSE_ONE_ID, healthType))
        responseTwo.setLabel(HealthType.getResponse(Constants.HEALTH_RESPONSE_TWO_ID, healthType))
        responseThree.setLabel(HealthType.getResponse(Constants.HEALTH_RESPONSE_THREE_ID, healthType))
        responseFour.setLabel(HealthType.getResponse(Constants.HEALTH_RESPONSE_FOUR_ID, healthType))
        responseFive.setLabel(HealthType.getResponse(Constants.HEALTH_RESPONSE_FIVE_ID, healthType))
    }
    
    override func onResult(requestCode: Int, resultCode: Int, data: Any?) {
        if (requestCode == HealthController.HEALTH_REQUEST_CODE && resultCode == ResultCode.RESULT_OK.value) {
            self.setResult(ResultCode.RESULT_OK.value)
            self.finish()
        }
    }
    
    func setOnClickListeners() {
        
        backButton.setOnClickListener {
            self.finish()
        }
        
        nextButton.setOnClickListener {
            self.hideKeyboard()
            
            if self.isSelectionValid() {
                let bundle = Boundle()
                bundle.putInt(Extra.HEALTH_MOBILITY.key, self.mobilityResponse)
                bundle.putInt(Extra.HEALTH_SELF_CARE.key, self.selfcareResponse)
                bundle.putInt(Extra.HEALTH_ACTIVITY.key, self.usualActivitiesResponse)
                bundle.putInt(Extra.HEALTH_ANXIETY.key, self.response)
                Router.instance
                    .controllerTransition(ControllerTransition.LEFT_TO_RIGHT)
                    .startBaseControllerForResult(self, Controllers.HEALTH_PAIN, bundle, HealthController.HEALTH_REQUEST_CODE)
            } else {
                Toast.showLongToast(self.view, StringProvider.get("health_select_something"))
            }
        }
        
        responseOne.checkbox.isUserInteractionEnabled = false
        responseTwo.checkbox.isUserInteractionEnabled = false
        responseThree.checkbox.isUserInteractionEnabled = false
        responseFour.checkbox.isUserInteractionEnabled = false
        responseFive.checkbox.isUserInteractionEnabled = false
        
        responseOne.setOnClickListener {
            self.responseOne.checkbox.toggle()
            if self.responseOne.checkbox.isChecked {
                self.response = Int(Constants.HEALTH_RESPONSE_ONE_ID) ?? Constants.INVALID
                self.responseTwo.checkbox.isChecked = false
                self.responseThree.checkbox.isChecked = false
                self.responseFour.checkbox.isChecked = false
                self.responseFive.checkbox.isChecked = false
            }
        }
        
        responseTwo.setOnClickListener {
            self.responseTwo.checkbox.toggle()
            if self.responseTwo.checkbox.isChecked {
                self.response = Int(Constants.HEALTH_RESPONSE_TWO_ID) ?? Constants.INVALID
                self.responseOne.checkbox.isChecked = false
                self.responseThree.checkbox.isChecked = false
                self.responseFour.checkbox.isChecked = false
                self.responseFive.checkbox.isChecked = false
            }
        }
        
        responseThree.setOnClickListener {
            self.responseThree.checkbox.toggle()
            if self.responseThree.checkbox.isChecked {
                self.response = Int(Constants.HEALTH_RESPONSE_THREE_ID) ?? Constants.INVALID
                self.responseOne.checkbox.isChecked = false
                self.responseTwo.checkbox.isChecked = false
                self.responseFour.checkbox.isChecked = false
                self.responseFive.checkbox.isChecked = false
            }
        }
        
        responseFour.setOnClickListener {
            self.responseFour.checkbox.toggle()
            if self.responseFour.checkbox.isChecked {
                self.response = Int(Constants.HEALTH_RESPONSE_FOUR_ID) ?? Constants.INVALID
                self.responseOne.checkbox.isChecked = false
                self.responseTwo.checkbox.isChecked = false
                self.responseThree.checkbox.isChecked = false
                self.responseFive.checkbox.isChecked = false
            }
        }
        
        responseFive.setOnClickListener {
            self.responseFive.checkbox.toggle()
            if self.responseFive.checkbox.isChecked {
                self.response = Int(Constants.HEALTH_RESPONSE_FIVE_ID) ?? Constants.INVALID
                self.responseOne.checkbox.isChecked = false
                self.responseTwo.checkbox.isChecked = false
                self.responseThree.checkbox.isChecked = false
                self.responseFour.checkbox.isChecked = false
            }
        }
    }
    
    private func isSelectionValid() -> Bool {
        if (responseOne.isChecked() || responseTwo.isChecked() || responseThree.isChecked() || responseFour.isChecked() || responseFive.isChecked()) && response != Constants.INVALID {
            return true
        }
        return false
    }
}
