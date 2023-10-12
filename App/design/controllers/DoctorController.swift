//
//  DoctorController.swift
//  BaseApp
//
//  Created by Omar Brugna on 23/06/2023.
//

import UIKit

class DoctorController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var tourPanel: MainPanelComponent!
    @IBOutlet var registerPanel: MainPanelComponent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.setTitle(Environment.APP_NAME)
        toolbar.showMenuComponent()
        
        prepare()
    }
    
    fileprivate func prepare() {
        
        if Preferences.user.isUserRegistered() {
            tourPanel.setPanel(MainPanelType.START_STUDY_WITH_NAME, Environment.APP_NAME)
            registerPanel.visibility = .invisible
        } else {
            tourPanel.setPanel(MainPanelType.TOUR)
            registerPanel.visibility = .visible
            registerPanel.setPanel(MainPanelType.REGISTER)
        }
        
        tourPanel.setOnClickListener {
            if Preferences.user.isUserRegistered() {
                let dialog = StartStudyDialog()
                dialog.setCancelable(false)
                dialog.setConfirmListener {
                    Preferences.user.studyStarted = true
                    Preferences.user.dateStudyStarted = TimeUtils.getCurrent()
                    Router.instance
                        .controllerTransition(.FADE)
                        .homepage(self)
                }
                dialog.setCancelListener {
                    // do nothing
                }
                dialog.show()
            } else {
                Router.instance.startBaseController(self, Controllers.TOUR)
            }
        }
        
        registerPanel.setOnClickListener {
            Router.instance.startBaseController(self, Controllers.PATIENT_DETAILS)
        }
    }
}

