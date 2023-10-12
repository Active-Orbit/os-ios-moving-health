//
//  SuccessMessageController.swift
//  BaseApp
//
//  Created by Omar Brugna on 10/07/2023.
//

import UIKit

class SuccessMessageController: BaseController {
    
    @IBOutlet var descriptionLabel: BaseLabel!
    @IBOutlet var closeButton: BaseButton!
    
    fileprivate var successMessage = SuccessMessageType.UNDEFINED
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        let successMessageID = controllerBoundle.getInt(Extra.SUCCESS_MESSAGE.key)
        if successMessageID != Constants.INVALID {
            successMessage = SuccessMessageType.getById(successMessageID)
        } else {
            Exception("Missing object identifier on \(className)")
        }
        
        prepare()
    }
    
    fileprivate func prepare() {
        
        descriptionLabel.text = successMessage.message
        
        closeButton.setOnClickListener {
            switch self.successMessage {
                case SuccessMessageType.LOCATION_PERMISSION: self.manageOnBoarding()
                case SuccessMessageType.BATTERY_PERMISSION: self.manageOnBoarding()
                case SuccessMessageType.UNUSED_RESTRICTIONS: self.manageOnBoarding()
                case SuccessMessageType.ON_BOARDING_COMPLETED: self.manageOnBoarding()
                case SuccessMessageType.REGISTRATION:
                    Router.instance
                        .controllerTransition(.BOTTOM_TO_TOP)
                        .homepage(self)
                case SuccessMessageType.MEDICINE_REPORTED: self.finishAndRemoveTask()
                case SuccessMessageType.SYMPTOM_REPORTED: self.finishAndRemoveTask()
                case SuccessMessageType.DISMISS_PATIENT:
                    let _ = Router.instance
                        .controllerTransition(.FADE)
                        .backToController(self, Controllers.SPLASH)
                case SuccessMessageType.UNDEFINED:
                    Logger.e("Undefined success message type on \(self.className)")
                    let _ =  Router.instance
                        .controllerTransition(.FADE)
                        .backToController(self, Controllers.SPLASH)
            }
        }
    }
    
    fileprivate func manageOnBoarding() {
        // TODO
    }

    fileprivate func finishAndRemoveTask() {
        // TODO
    }
}

