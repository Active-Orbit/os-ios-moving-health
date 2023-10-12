//
//  SettingsController.swift
//  App
//
//  Created by George Stavrou on 07/07/2023.
//

import UIKit

class SettingsController: BaseController {

    @IBOutlet var toolbar: Toolbar!
    
    @IBOutlet var screenTitle: BaseLabel!
    
    @IBOutlet var locationServices: HelpComponent!
    @IBOutlet var patientDetails: HelpComponent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        prepare()
        setClickListeners()
                
    }
    
    
    func prepare() {
        
        patientDetails.setTitle(StringProvider.get("patient_details"))
        locationServices.setTitle(StringProvider.get("location_services_title_one"))
        
        
        if Preferences.user.isUserRegistered() {
            patientDetails.visibility = .visible
        } else {
            patientDetails.visibility = .invisible
        }


    }
    
    
    func setClickListeners() {
        
        patientDetails.setOnClickListener {
            let bundle = Boundle()
            bundle.putBoolean(Extra.FROM_MENU.key, true)
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.PATIENT_DETAILS, bundle)
        }
        
        locationServices.setOnClickListener {
            let bundle = Boundle()
            bundle.putBoolean(Extra.FROM_MENU.key, true)
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.ONBOARDING_LOCATION, bundle)
            
        }
        
 
    }
    
    
}
