//
//  WelcomeController.swift
//  BaseApp
//
//  Created by Omar Brugna on 23/06/2023.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

class WelcomeController: BaseController {

    @IBOutlet weak var getStartedButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        Preferences.lifecycle.welcomeShown = true
        
        getStartedButton.setOnClickListener {
            if Preferences.lifecycle.tourShown {
                Router.instance
                    .controllerTransition(ControllerTransition.BOTTOM_TO_TOP)
                    .startBaseController(self, Controllers.CONSENT_PRIVACY)
            } else {
                Router.instance
                    .controllerTransition(ControllerTransition.FADE)
                    .startBaseController(self, Controllers.TOUR)
            }
        }
    }
}

